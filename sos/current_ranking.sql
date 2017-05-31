select
r.speller_name,
rating from scripps._spellers s
join
(select distinct speller_name,year
from scripps.results) r
on (r.speller_name,r.year)=
   (s.speller_name,2017)
order by rating desc;
