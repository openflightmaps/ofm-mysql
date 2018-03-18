#!/bin/bash
pwd
source .env
schemalex "mysql://$DB_USERNAME:$DB_PASSWORD@($DB_HOSTNAME)/$1" "$2"
