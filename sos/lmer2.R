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
 else 1 end) as correct,
a.a_n as n
from scripps.results r
join scripps.appearances a
  on (a.speller_name,a.year)=(r.speller_name,r.year)
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

words$n <- as.factor(words$n)

attach(words)

pll <- list()

fp <- data.frame(year,round,n)
fpn <- names(fp)

rp <- data.frame(speller)
rpn <- names(rp)

for (n in fpn) {
  df <- fp[[n]]
  level <- as.matrix(attributes(df)$levels)
  parameter <- rep(n,nrow(level))
  type <- rep("fixed",nrow(level))
  pll <- c(pll,list(data.frame(parameter,type,level)))
}

for (n in rpn) {
  df <- rp[[n]]
  level <- as.matrix(attributes(df)$levels)
  parameter <- rep(n,nrow(level))
  type <- rep("random",nrow(level))
  pll <- c(pll,list(data.frame(parameter,type,level)))
}

# Model parameters

parameter_levels <- as.data.frame(do.call("rbind",pll))
dbWriteTable(con,c("scripps","_parameter_levels"),parameter_levels,row.names=TRUE)

model <- correct ~ year+(1|speller)+round+n

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

dbWriteTable(con,c("scripps","_basic_factors"),as.data.frame(combined),row.names=TRUE)

write.csv(combined, file = "foo.csv")

quit("no")
