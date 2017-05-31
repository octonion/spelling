#sink("diagnostics/lmer.txt")

library("lme4")
library("RPostgreSQL")

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,dbname="spelling")

query <- dbSendQuery(con, "
select
r.year as year,
r.speller_name as speller,
--coalesce(s.state,'NA') as state,
r.round_id as round,
(case when r.bonus_error='E' then 0
 else 1 end) as correct
from scripps.results r
--left join scripps.spellers s
--  on (s.year,s.speller_name)=
--     (r.year,r.speller_name)
where
r.year>=2012
;")

words <- fetch(query,n=-1)
dim(words)

words$year <- as.factor(words$year)
words$round <- as.factor(words$round)
#words$state <- as.factor(words$state)

attach(words)

fp <- data.frame(year,round)
fpn <- names(fp)

rp <- data.frame(speller)
rpn <- names(rp)

model <- correct ~ year+(1|speller)+round

fit <- glmer(model,
             data=words,
	     family=binomial,
	     verbose=TRUE,
	     nAGQ=0,
	     control=glmerControl(optimizer = "nloptwrap"))

fit
summary(fit)
fixef(fit)
ranef(fit)

# Fixed factors

f <- fixef(fit)
fn <- names(f)

# Random factors

r <- ranef(fit)
rn <- names(r) 

results <- list()

for (n in fn) {

  df <- f[[n]]

  factor <- n
  level <- n
  type <- "fixed"
  estimate <- df

  results <- c(results,list(data.frame(factor,type,level,estimate)))

 }

for (n in rn) {

  df <- r[[n]]

  factor <- rep(n,nrow(df))
  type <- rep("random",nrow(df))
  level <- row.names(df)
  estimate <- df[,1]

  results <- c(results,list(data.frame(factor,type,level,estimate)))

 }

combined <- as.data.frame(do.call("rbind",results))

write.csv(combined, file = "foo.csv")

quit("no")
