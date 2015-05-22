begin;

select
n,
count(*) as f
from
(select
lower(word) as word,
count(*) as n
from scripps.results
group by lower(word)) as w
group by n order by n;

copy (
select
n,
count(*) as f
from
(select
lower(word) as word,
count(*) as n
from scripps.results
group by lower(word)) as w
group by n order by n
) to '/tmp/frequency.csv' csv header;

commit;

