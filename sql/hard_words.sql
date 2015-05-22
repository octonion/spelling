begin;

select
round_id as rd,
year,
word,
word_url as url,
(case when bonus_error='E' then 'wrong' else 'right' end) as outcome
from scripps.results
where word_url is not null
and round_id >= 10
order by round_id desc;

copy (
select
round_id as rd,
year,
word,
word_url as url,
(case when bonus_error='E' then 'wrong' else 'right' end) as outcome
from scripps.results
where word_url is not null
and round_id >= 10
order by round_id desc
) to '/tmp/hard_words.csv' csv header;

commit;

