copy (
select
w.origin,
(sum(case when r.word=r.spelled then 1.0 else 0.0 end)/count(*))::numeric(4,3) as pct,
count(*) as n
from scripps.results r
join scripps.words w on lower(w.word)=lower(r.word)
where round_id>=2 group by w.origin
having count(*)>=10 order by pct asc
) to '/tmp/origin_success.csv' csv header;

