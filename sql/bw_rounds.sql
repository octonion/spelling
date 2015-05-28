select
year,
round_id as rd,
1000*count(*) as wp
from scripps.results
where year >= 2010
and round_id in (2,3)
group by year,round_id
order by wp desc;
