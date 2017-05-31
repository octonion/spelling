begin;

drop table if exists scripps._factors;

create table scripps._factors (
        row_id		      text,
	factor		      text,
	type		      text,
	level		      text,
	estimate	      float
);

copy scripps._factors from '/tmp/foo.csv' with delimiter as ',' csv header;

commit;
