select
s.speller_name as speller,
s.year as year,
a.a_n as n,
(coalesce(ar.estimate,0.0)+sr.estimate::numeric(4,3)) as rating
from scripps.s s
join scripps._factors sr
  on (sr.level)=(s.speller_name)
join scripps.appearances a
  on (a.speller_name,a.year)=(s.speller_name,s.year)
left join scripps._factors ar
  on (ar.level)=('n'||a.a_n::text)
where
s.year=2018
order by rating desc;

/*
select
s.speller_name as speller,
s.year as year,
a.a_n as n,
(sr.factor+ar.factor)::numeric(4,3) as rating
from scripps.s s
join scripps._factors sr
  on (sr.level)=(s.speller_name)
join scripps.appearances a
  on (a.speller_name,a.year)=(s.speller_name,s.year)
join scripps._factors ar
  on (ar.parameter,ar.level)=('n',a.a_n::text)
where
s.year=2018
order by rating desc;
*/
