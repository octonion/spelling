begin;

select
r.round_id,
r.word,
w.origin,
(case when r.bonus_error='E' then 'wrong' else 'right' end) as outcome
from scripps.results r
left join scripps.words w
on (w.word)=(r.word)
where r.year=2014
and r.round_id >= 10
order by round_id,speller_id;

copy (
select
r.round_id,
r.word,
w.origin,
(case when r.bonus_error='E' then 'wrong' else 'right' end) as outcome
from scripps.results r
left join scripps.words w
on (w.word)=(r.word)
where r.year=2014
and r.round_id >= 10
order by round_id,speller_id
) to '/tmp/word_origins.csv' csv header;

commit;
