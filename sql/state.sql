select
trim(both from split_part(speller_city,',',1+length(speller_city)-length(replace(speller_city,',','')))) as state,
count(*) as n
from scripps.results
where round_id=2
group by state
order by n desc;
