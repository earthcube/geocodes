# Documentation for the Geocodes Container Stack


## Overview:
1. Configure a base server
2. Setup services containers
3. Intial setup of services and load data
3. Setup Gepcodes UI containers,

### Requirements prior to starting
Three sections to know prior to installing
* All
* Production
* Local Development

####  ALL
You need to be able to run `docker compose version`

Should be > v2.13 `docker compose  --help` needs to show the -p --project flag
!!! warning     "**Known issue**" 
    with (at least) Ubuntu default docker package. Install the [official docker package](https://docs.docker.com/engine/install/ubuntu/)

    ```shell
    docker compose version
    Docker Compose version v2.13.0
    ```
####  Production

!!! warning   "YOU NEED SETUP DNS."  
    Setup [DNS names for the aliases](https://raw.githubusercontent.com/earthcube/geocodes/main/deployment/hosts.geocodes) 
    so the treafik routing will work

####  Local(Tutorial)/Development

!!! note 
    **TODO:** there are compose-local.yaml configurations. 

* The run_local.sh works. There is no portainer for these. all command line.
* minio (and maybe others) use ports. [See "-local path " at this page](./stack_machines.md)

### Creating and managing CONTAINERS

1. [Configure a base server](./setup_base_machine_configuration.md)
    * docker
    * git clone https://github.com/earthcube/geocodes.git
    * cd geocodes/deployment
    * setup domain names
    * create .env file
    * add  (traefik and portainer ) build-machine-compose.yaml
    * (add headless with larger shared memory) ./run_gleaner.sh   

2. [Use portainer to setup geocodes services and geocodes user interface (and services )](./setup_geocodes_services_containers.md)
    * setup and configure services
        * create env variables file for the services
        * add stack services-compose.yaml to portainer

1. [Initial Setup of datastores and loading of sample data](./setup_indexing_with_gleanerio.md)
    * Setup datastores for s3 and graph
    * Install software glcon
      * create configuration gctest `./glcon config init --cfgName gctest`
    * copy file with repository information (sitemap location and name)
    * edit file tell ingest what services to utilize 
    * generate a configuration updated with the source and configuration `./glcon config generate --cfgName gctest`
    * run ingest `./glcon gleaner batch --cfgName gctest`
        * check minioadmin to see that bucket gctest was populated
    * convert to triples and upload: `./glcon nabu prefix --cfgName gctest`
        * run sparql query at graph service to see that triples got converted and uploaded
    * create a materilized view of the data using summarize (TB DOCUMENTED BY MBCODE)

1. [Use portainer to setup geocodes user interface (and services )](./setup_geocodes_ui_containers.md)
    * setup and configure user infertace and it's services
        * create a facets config
        * upload facets config to portainer/docker
        * add  stack gecodes-compose.yaml to portainer
1. [Creating a community instance (aka tennant)](./tenant/)

### Data Loading

* [Testing](./indexing_with_gleanerio_for_testing.md)
* [Create a  'Production' config](production/creatingProductionConfigs.md) 
* [Ingest]

### NOTES
* [Troubleshooting](troubleshooting.md)

??? info "system image"
    ~~~mermaid
    flowchart TB
        services-- deployed by -->portainer
        geocodes-- deployed by  --> portainer
        gleaner-- deployed by  --> portainer
        facetsearch-- routes --> traefik
        facetsearchservices-- routes-->traefik
        oss-- routes-->traefik
        triplestore-- routes --> traefik
        sparqlgui-- routes --> traefik
        subgraph gleaner
           headless
        end
        subgraph geocodes
           facetsearch-->facetsearchservices
        end
        subgraph services
           oss["oss s3"]
           sparqlgui
           triplestore["graph -- triplestore"]
        end
    
        subgraph base
           traefik<-- routes -->portainer
        end
    
    ~~~
