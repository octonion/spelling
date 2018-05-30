#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'spelling';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb spelling;"
   eval $cmd
fi

psql spelling -f schema/create_schema.sql

#cp csv/scripps_results.csv /tmp/results.csv
cat csv/scripps_results_201[12345678].csv >> /tmp/results.csv
psql spelling -f loaders/load_scripps_results.sql
rm /tmp/results.csv

cat csv/scripps_results_19??.csv >> /tmp/results.csv
cat csv/scripps_results_200?.csv >> /tmp/results.csv
cat csv/scripps_results_2010.csv >> /tmp/results.csv
psql spelling -f loaders/load_scripps_results_older.sql
rm /tmp/results.csv

cat csv/spellers_*csv >> /tmp/spellers.csv
psql spelling -f loaders/spellers.sql
rm /tmp/spellers.csv
