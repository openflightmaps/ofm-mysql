help:
	echo "usage: make [compare-ofm|compare-ofmservices]"
dep:
	go get github.com/schemalex/git-schemalex/cmd/git-schemalex
	go install github.com/schemalex/git-schemalex/cmd/git-schemalex
assemble:
	cat schema/ofm/*.sql > schema/ofm.sql
	cat schema/ofmServices/*.sql > schema/ofmServices.sql
dbconfig: dep assemble .env

compare-ofm: dbconfig
	./compare.sh ofm schema/ofm.sql
compare-ofmservices: dbconfig
	./compare.sh ofmServices schema/ofmServices.sql

dump-ofm-procedures: dbconfig
	./dump-procedures.sh ofm schema/ofm-procedures/procedures.sql
dump-ofmServices-procedures: dbconfig
	./dump-procedures.sh ofm schema/ofmServices-procedures/procedures.sql
