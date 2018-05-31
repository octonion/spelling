#!/bin/bash

psql spelling -f sos/s.sql
psql spelling -f appearances.sql

psql spelling -c "drop table if exists scripps._basic_factors;"
#psql spelling -c "drop table if exists scripps._factors;"
psql spelling -c "drop table if exists scripps._parameter_levels;"

R --vanilla -f sos/lmer2.R
psql spelling -f sos/current_ranking.sql > sos/current_ranking.txt

