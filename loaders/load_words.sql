begin;

drop table if exists scripps.words;

create table scripps.words (
	word		      text,
	origin		      text
--	primary key (word)
);

copy scripps.words from '/tmp/words.csv' with delimiter as ',' csv;

commit;
