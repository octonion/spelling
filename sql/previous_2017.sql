copy (
select
r.word,
r.round_id as rd,
r.bonus_error as r,
p.n,
min,
max,
p.year
from scripps.results r
join (
select
word,
count(*) as n,
min(round_id) as min,
max(round_id) as max,
max(year) as year
from scripps.results where year<=2016 group by word) p
  on lower(p.word)=lower(r.word)
where r.year=2017
order by rd asc,n desc
) to '/tmp/previous_2017.csv' csv header;
