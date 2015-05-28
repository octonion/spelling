begin;

create temporary table ro (
	year		      integer,
	round_id	      integer,
	speller_id	      integer,
	speller_name	      text,
	speller_url	      text,
	speller_city	      text,
	word		      text,
	spelled		      text,
	bonus_error	      text,
	primary key (year,round_id,speller_id)
);

copy ro from '/tmp/results.csv' with delimiter as ',' csv;

insert into scripps.results
(year,round_id,speller_id,speller_name,speller_url,speller_city,word,
word_meaning,word_url,
spelled,bonus_error)
(select
year,round_id,speller_id,speller_name,speller_url,speller_city,word,
NULL as word_meaning,
NULL as word_url,
spelled,bonus_error
from ro
);

-- Separate out

update scripps.results
  set word=lower(unaccent(word));

commit;
