begin;

drop table if exists scripps.s;

create table scripps.s (
       speller_name		text,
       year			integer
);

insert into scripps.s
(speller_name,year)
(
select
distinct speller_name,year
from scripps.results
);

commit;
