select
length(word) as length,
avg(case when bonus_error='N' then 1  when bonus_error='E' then 1 else 0 end)::numeric(4,3) as er,
count(*) as n
from scripps.results
group by length(word)
order by length(word);
