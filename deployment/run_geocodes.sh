#!/bin/bash

helpFunction()
{
   echo "run geocodes from command line"
   echo "Usage: $0 -e envfile  -r  -d "
   echo -e "\t-e envfile to use"
   echo -e "\t-r refresh geocodes comtainers"
   echo -e "\t-d RUN detached"
      echo -e "\tMAC: You may have to add /tmp/gleaner to the file sharing preferences in the docker app"
   exit 1 # Exit script after printing help
}

while getopts "e:r:d:" opt
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
fi

if [ $detached ]
  then
    docker-compose --env-file $envfile  -f services-compose.yaml -f geocodes-compose.yaml  up -d
  else
    docker-compose --env-file $envfile  -f services-compose.yaml -f geocodes-compose.yaml  up
fi
