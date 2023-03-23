# Documentation for the Geocodes Container Stack


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
  
## Overview:
1. Configure a base server
2. Setup services containers
3. Setup Gleaner containers
3. Intial setup of services and load data
3. Setup Gepcodes UI containers,

## What to learn from deploying the stack, and the indexing application

* how to deploy containers
* how to run indexing using gleaner
    * initial setup to use a test daatase
    * production setup to use the sources google spreadsheet
    * to learn to renenerate the config files when you edit using glcon.
* how to setup the UI
* how to reconfigure the UI 

!!! warn "Clean Machine"
    These are instructions for a clean machine. Your mileage will vary if you are trying to install this stack on
    a developers workstation.
    If you are experienced, then you can probably deploy the docker stacks on a server with docker running.
    The stack uses treafik labels to manage the roures between the web server and the containers. It is not
    a task for the faint of heart, but IMOHO, it is more automatic that nginx or caddy reverse proxy routing.
    and allows us to deploy 'tenant' client stacks using configured data steores for each client in the services stack.
    Probably can be done with helm charts.

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

??? note   "Local(Tutorial)/Development"
    **TODO:** there are compose-local.yaml configurations. NOT WELL TESTED

    * The run_local.sh works. There is no portainer for these. Managed by command line.
    *     minio (and maybe others) use ports. [See "-local path " at this page](./stack_machines.md)

### Creating and managing CONTAINERS

1. [Configure a base server](./setup_base_machine_configuration.md)
    * docker
    * setup directory and groups for installing geocodes
    * git clone https://github.com/earthcube/geocodes.git
    * cd geocodes/deployment
    * setup domain names
    * create .env file
    * add  (traefik and portainer ) build-machine-compose.yaml
    * (add headless with larger shared memory) ./run_gleaner.sh   

2. [Use portainer to setup geocodes services ](./setup_geocodes_services_containers.md)
    * setup and configure services
        * create env variables file for the services
        * add stack services-compose.yaml to portainer
1. [Setup Gleaner containers](./setup_gleaner_container.md)
   * run shell script `run_gleaner.sh`
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
* Production
    * [Create a  'Production' config](production/creatingAndLoadingProduction.md) 
    * [Production Fragments](production/production_configs.md)


### NOTES
* [Troubleshooting](troubleshooting.md)


