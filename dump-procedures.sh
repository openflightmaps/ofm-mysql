#!/bin/bash
set -e
source .env

DB=$1
OUT=$2

echo running mysqldump -u $DB_USERNAME --password=$DB_PASSWORD -h $DB_HOSTNAME  --port=$DB_PORT -R -d -n -t $DB
mysqldump -u $DB_USERNAME --password=$DB_PASSWORD -h $DB_HOSTNAME  --port=$DB_PORT -R -d -n -t $DB > $OUT
