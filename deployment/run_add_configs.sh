#/bin/bash

# the goal of this is to add configuration files.
helpFunction()
{
   echo "add configuration files needed for services and UI containers "
   echo "Usage: $0 -f facets_config  -t fuseki_config"
   echo -e "\t-f config for facets UI. in facets/config"
   echo -e "\t-t fuseki triplestore config fuskei/configuraiton"
   exit 1 # Exit script after printing help
}
detached=true

while getopts "t:f" opt
do
   case "$opt" in
      e ) facets_config="$OPTARG" ;;
      u ) fuseki_config="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ ! $facets_config ]
  then
     facets_config="./facets/config.yaml"
fi
if  `docker config ls | grep -q "facets_config"` ; then
   echo facets_config exists as swarm, deleting original
   docker config rm facets_config
   docker config create facets_config $facets_config
   echo THERE MAY BE AN ERROR if so stop the geocodes stack, and add manually, then restart stack
else
   echo creating facets_config
 # facets config
    docker config create facets_config $facets_config
fi


if [ ! $fuseki_config ]
  then
   fuseki_config="./fuseki/configuration/earthcube.ttl"
fi
if  `docker config ls | grep -q "fuseki_config` ; then
   echo fuseki_config exists as swarm, deleting original
   docker config rm fuseki_config
   docker config create fuseki_config $fuseki_config
   echo THERE MAY BE AN ERROR if so stop the geocodes stack, and add manually, then restart stack
else
   echo creating fuseki_config
 # facets config
    docker config create fuseki_config $facets_config
fi

