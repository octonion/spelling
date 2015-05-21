begin;

drop table if exists scripps.results;

create table scripps.results (
	year		      integer,
	round_id	      integer,
	speller_id	      integer,
	speller_name	      text,
	speller_url	      text,
	speller_city	      text,
	word		      text,
	word_meaning	      text,
	word_url	      text,
	spelled		      text,
	error		      text,
	primary key (year,round_id,speller_id)
);

copy scripps.results from '/tmp/results.csv' with delimiter as ',' csv;

commit;
