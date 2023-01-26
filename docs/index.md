# Documentation for the Geocodes Container Stack

Table of Contents 

[TOC]

## Overview:

### Requirements prior to starting
Three sections to know prior to installing
* All
* Production
* Local Development

####  ALL
    * Docker, v2+ `docker compose version` needs to show the -p --project flag
!!! important     "**Known issue**" 
    with (at least) Ubuntu default docker package. Install the [official docker package](https://docs.docker.com/engine/install/ubuntu/)

    ```shell
    docker compose version
    Docker Compose version v2.13.0
    ```
####  Production

!!! important   "YOU NEED SETUP DNS."  
    Setup [DNS names for the aliases](https://raw.githubusercontent.com/earthcube/geocodes/main/deployment/hosts.geocodes) 
    so the treafik routing will work

####  Local(Tutorial)/Development

!!! note 
    **TODO:** there are compose-local.yaml configurations. 

* The run_local.sh works. There is no portainer for these. all command line.
* minio (and maybe others) use ports. [See "-local path " at this page](./stack_machines.md)

### Creating and managing CONTAINERS

  * [configure a base server](./setup_base_machine_configuration.md)
      * docker
      * git clone https://github.com/earthcube/geocodes.git
      * cd geocodes/deployment
      * setup domain names
      * create .env file
      * add  (traefik and portainer ) build-machine-compose.yaml
      * (add headless with larger shared memory) ./run_gleaner.sh   
  * [Use portainer to setup geocodes services and geocodes user interface (and services )](./setup_geocodes_containers.md)
      * setup and configure services
          * create env variables file for the services
          * add stack services-compose.yaml to portainer
      * setup and configure user infertace and it's services
          * create a facets config
          * upload facets config to portainer/docker
          * add  stack gecodes-compose.yaml to portainer

### Data Loading

* [Testing](indexing_with_gleanerio_for_testing.md(./))
* [Create a  'Production' config](production/creatingProductionConfigs.md) 
* [Ingest]

### NOTES
* [Troubleshooting](troubleshooting.md)

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
