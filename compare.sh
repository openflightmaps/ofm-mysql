#!/bin/bash
pwd
source .env
schemalex "mysql://$DB_USERNAME:$DB_PASSWORD@($DB_HOSTNAME:$DB_PORT)/$1" "$2"
