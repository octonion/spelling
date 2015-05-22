begin;

select
year,
lower(word),
round_id
from scripps.results
where
(year,round_id) in
(select year,max(round_id)
from scripps.results group by year)
order by year;

copy (
select
year,
lower(word),
round_id
from scripps.results
where
(year,round_id) in
(select year,max(round_id)
from scripps.results group by year)
order by year
) to '/tmp/championship.csv' csv header;

commit;
