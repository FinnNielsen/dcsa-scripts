#!/usr/bin/env bash

#
# Simple script to quickly start the docker-comtainers in a dcsa repo
# and initialize the database since the repos does not contain a proper
# local-dev set up and control scripts to do this.
#
# Examples:
#		dcsa.sh start
#		dcsa.sh stop
#		dcsa.sh stop start
#

if [ ! -f docker-compose.yml ]; then
	echo -e "\e[0;31mno docker-compose.yml\e[0m\n"
	exit 1
fi

while [[ $# -gt 0 ]]; do
	option="$1"
	shift

	case "$option" in
		start)
			echo -e "\e[0;34mdocker-compose up -d -V --build\e[0m\n"
			docker-compose up -d -V --build

			if [ -d "DCSA-Information-Model/datamodel/initdb.d" ]; then
				sleep 2
				echo -e "\e[0;34m\nInitializing database\e[0m\n"
				cd "DCSA-Information-Model/datamodel/initdb.d"
				cat *.sql ../testdata.d/* | docker exec -i dcsa_db psql -h localhost -U postgres postgres
				cd ../../..
			else
				echo -e "\e[0;31m\nNo DCSA-Information-Model/datamodel/initdb.d\e[0m\n"
			fi
		;;
		stop)
			echo -e "\e[0;34mdocker-compose kill && docker-compose down\e[0m\n"
			docker-compose kill && docker-compose down
		;;
		#dbconnect)
		#	#docker exec -it dcsa_db psql -h localhost -U postgres postgres
		#	docker exec -it dcsa_db psql -h localhost -U postgres dcsa_openapi
		#;;
	esac
done
