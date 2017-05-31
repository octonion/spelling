begin;

drop table if exists scripps._spellers;

create table scripps._spellers (
	speller_name	      text,
	rating		      float,
	primary key (speller_name)
);

copy scripps._spellers from '/tmp/foo.csv' with delimiter as ',' csv;

commit;
