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

scriptDir=$(dirname $(readlink -f "$0"))


if [ ! -f docker-compose.yml ]; then
	echo -e "\e[0;31mno docker-compose.yml\e[0m\n"
	exit 1
fi

pgwebArg="--profile pgweb"
if ! $(grep pgweb docker-compose.yml > /dev/null 2>&1); then
	pgwebArg="-f docker-compose.yml -f $scriptDir/docker-compose.yml"
fi

while [[ $# -gt 0 ]]; do
	option="$1"
	shift

	case "$option" in
		start)
			echo -e "\e[0;34mdocker compose up -d -V --build\e[0m\n"
			docker compose $pgwebArg --env-file=$scriptDir/.env up -d -V --build

		;;
		stop)
			echo -e "\e[0;34mdocker compose kill && docker-compose down\e[0m\n"
			docker compose $pgwebArg kill && docker compose $pgwebArg down
		;;
		#dbconnect)
		#	#docker exec -it dcsa_db psql -h localhost -U postgres postgres
		#	docker exec -it dcsa_db psql -h localhost -U postgres dcsa_openapi
		#;;
	esac
done
