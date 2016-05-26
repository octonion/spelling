copy (
select
r.word,
r.bonus_error as r,
p.n,
min,
max,
p.year
from scripps.results r
join (
select word,count(*) as n,
min(round_id) as min,
max(round_id) as max,
max(year) as year
from scripps.results where year<=2015 group by word) p
  on (p.word)=(r.word)
where r.year=2016
order by n desc
) to '/tmp/previous_2016.csv' csv header;
