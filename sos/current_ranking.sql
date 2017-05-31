select
f.level as speller,
f.estimate as rating
from scripps._factors f
join
(select distinct speller_name,year
from scripps.results) r
on (r.speller_name,r.year)=
   (f.level,2017)
order by rating desc;
