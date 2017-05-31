#sink("diagnostics/lmer.txt")

library("lme4")
library("RPostgreSQL")

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,dbname="spelling")

query <- dbSendQuery(con, "
select
speller_name as speller,
round_id as round,
(case when bonus_error='E' then 0
 else 1 end) as correct
from scripps.results
where
year>=2012
;")

words <- fetch(query,n=-1)
dim(words)

words$round <- as.factor(words$round)

model <- correct ~ (1|speller)+round

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

quit("no")
