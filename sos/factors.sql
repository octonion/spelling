begin;

drop table if exists scripps._factors;

create table scripps._factors
(
	parameter		text,
	level			text,
	type			text,
	factor			float
);

insert into scripps._factors
(parameter,level,type,factor)
(
select
pl.parameter,
pl.level,
pl.type,
coalesce(bf.estimate,0.0)
from scripps._parameter_levels pl
left join scripps._basic_factors bf
  on (bf.level)=(pl.parameter||pl.level)
where pl.type='fixed'
);

insert into scripps._factors
(parameter,level,type,factor)
(
select
pl.parameter,
pl.level,
pl.type,
coalesce(bf.estimate,0.0)
from scripps._parameter_levels pl
left join scripps._basic_factors bf
  on (bf.level)=(pl.level)
where pl.type='random'
);

commit;
