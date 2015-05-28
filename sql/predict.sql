select
lower(word) as word,
min(round_id) as min_r,
max(round_id) as max_r,
min(year) as min_y,
max(year) as max_y,
avg(year)::numeric(5,1) as avg_y,
(sum(
case when bonus_error in ('E','N') then 0
     else 1
end)::float/count(*))::numeric(4,3) as p,
count(*) as n
from scripps.results
where year>=1996
group by lower(word)
order by n desc, p desc, max_y asc;
