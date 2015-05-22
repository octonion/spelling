begin;

select
lower(word) as word,
avg(case when bonus_error='Y' or bonus_error is NULL then 0 else 1 end)::numeric(4,3) as err,
count(*) as n
from scripps.results
group by lower(word)
having count(*)>=4
order by n desc, err desc;

copy (
select
lower(word) as word,
avg(case when bonus_error='Y' or bonus_error is NULL then 0 else 1 end)::numeric(4,3) as err,
count(*) as n
from scripps.results
group by lower(word)
having count(*)>=4
order by n desc, err desc
) to '/tmp/words.csv' csv header;

commit;

