#!/bin/bash
# https://dockerswarm.rocks/traefik/
helpFunction()
{
   echo "setup a base portainer and traefik command line"
   echo "Usage: $0 -e envfile  -u "
   echo -e "\t-e envfile to use"
   echo -e "\t-u DO NOT RUN detached"
      echo -e "\tMAC: You may have to add /tmp/gleaner to the file sharing preferences in the docker app"
   exit 1 # Exit script after printing help
}
detached=true

while getopts "e:u" opt
do
   case "$opt" in
      e ) envfile="$OPTARG" ;;
      u ) detached=false ;;
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
    echo "OR PRODUCTION"
    echo "cp portainer.env .env"
    echo "OR"
    echo "cp {yourenv}.env .env"

    exit 1
fi

## need to docker (network|volume) ls | grep (traefik_proxy|traefik_proxy) before these calll
## or an error will be thrown
docker network create -d overlay --attachable traefik_proxy
docker network ls

echo Verify that the traefik_proxy network  SCOPE is swarm


echo $detached

# uses swarm :
if [ "$detached" = true ]
  then
    docker compose -p gleaner_via_shell --env-file $envfile  -f gleaner-compose.yaml  up -d
  else
    docker compose -p gleaner_via_shell --env-file $envfile  -f gleaner-compose.yaml  up
fi
