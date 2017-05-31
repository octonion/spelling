begin;

drop table if exists scripps.spellers;

create table scripps.spellers (
	year		      integer,
	state		      text,
	id		      integer,
	speller_name	      text,
	sponsor		      text
);

copy scripps.spellers from '/tmp/spellers.csv' csv;

commit;
