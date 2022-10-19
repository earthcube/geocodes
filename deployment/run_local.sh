#!/bin/bash

helpFunction()
{
   echo "run geocodes from command line"
   echo "Usage: $0 -e envfile  -u "
   echo -e "\t-e envfile to use"
#   echo -e "\t-r refresh geocodes containers"
   echo -e "\t-u do not run detached"
      echo -e "\tMAC: You may have to add /tmp/gleaner to the file sharing preferences in the docker app"
   exit 1 # Exit script after printing help
}

while getopts "e:rd" opt
do
   case "$opt" in
      e ) envfile="$OPTARG" ;;
      r ) refresh=true;;
      c ) detached=true ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ ! $envfile ]
  then
     envfile=".env"
#      envfile="portainer.env"
fi

if [ -f $envfile ]
  then
    echo "using " $envfile
  else
    echo "missing environment file. pass flag, or copy and edit file"
    echo "./run_base.sh -e file "

    echo "OR"
    echo "cp {yourenv}.env .env"

    exit 1
fi

docker volume create graph
docker volume create minio

if [ "$detached" = true ]
  then
    docker compose -p geocodes --env-file $envfile  -f geocodes-compose-local.yaml -f services-compose-local.yaml  up -d
  else
    docker compose -p geocodes --env-file $envfile  -f geocodes-compose-local.yaml -f services-compose-local.yaml   up
fi
