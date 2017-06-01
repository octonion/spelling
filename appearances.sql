begin;

drop table if exists scripps.appearances;

create table scripps.appearances (
       speller_name		text,
       year			integer,
       a_n			integer
);

insert into scripps.appearances
(speller_name,year)
(
select speller_name,year
from scripps.s
);

update scripps.appearances
set a_n=
(
select count(*) as a_n
from scripps.appearances a1
join scripps.appearances a2
  on ((a2.speller_name)=(a1.speller_name)
     and a2.year <= a1.year)
where
(a1.speller_name,a1.year)=(appearances.speller_name,appearances.year)
);

commit;
