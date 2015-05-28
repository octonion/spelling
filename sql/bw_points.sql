select
year,
sum(points) as sp
from
(
select year,speller_name,sum(100*round_id) as points
from scripps.results
where (bonus_error is null or bonus_error='Y')
group by year,speller_name,speller_id
order by points desc) p
where year >= 2010
group by year
order by sp desc;
