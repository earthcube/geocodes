#!/bin/bash
# https://dockerswarm.rocks/traefik/
helpFunction()
{
   echo "setup a base portainer and traefik command line"
   echo "Usage: $0 -e envfile  -u"
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
echo "This message is OK **Error response from daemon: network with name traefik_proxy already exists.** "
docker network create -d overlay --attachable traefik_proxy
docker network ls

echo NOTE: Verify that the traefik_proxy network  SCOPE is swarm

docker volume create traefik_data
docker volume create portainer_data
docker volume create graph
docker volume create graph_2
docker volume create fuseki_configuration
docker volume create fuseki_logs
docker volume create minio

echo run as detached: $detached

# uses swarm :
if [ "$detached" = true  ]
  then
    docker compose -p base --env-file $envfile  -f base-machine-compose.yaml  up  -d
  else
    docker compose -p base --env-file $envfile  -f base-machine-compose.yaml  up
fi
