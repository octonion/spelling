begin;

drop table if exists scripps._spellers;

create table scripps._spellers (
	speller_name	      text,
	rating		      float,
	primary key (speller_name)
);

--copy scripps._spellers from '/tmp/foo.csv' with delimiter as ',' csv;

insert into scripps._spellers
(speller_name,rating)
(
select level,estimate
from scripps._factors
where factor='speller'
);

commit;
