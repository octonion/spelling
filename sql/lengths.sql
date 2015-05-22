begin;

select
length(word) as length,
avg(case when bonus_error='N' then 1  when bonus_error='E' then 1 else 0 end)::numeric(4,3) as err,
count(*) as n
from scripps.results
group by length(word)
order by length(word);

copy (
select
length(word) as length,
avg(case when bonus_error='N' then 1  when bonus_error='E' then 1 else 0 end)::numeric(4,3) as err,
count(*) as n
from scripps.results
group by length(word)
order by length(word)
) to '/tmp/length.csv' csv header;

commit;

