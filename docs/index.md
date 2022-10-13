# Documentation for the Geocodes Container Stack

Table of Contents here


## Overview:
### Needs prior to starting
  * ALL
    * Docker, v2+ `docker compose --help` needs to show the -p --project flag
      * **Known issue** with (at least) Ubuntu default docker package. Install the [official docker package](https://docs.docker.com/engine/install/ubuntu/)
  * Production
    * YOU NEED SETUP DNS.  setup [DNS names for the aliases](../deployment/hosts.geocodes) 
      * so the treafik routing will work
  * Local(Tutorial)/Development
    * TODO: there are compose-local.yaml configurations. 
    * The run_local.sh works. There is no portainer for these. all command line.
    * minio (and maybe others) use ports. [See "-local path " at this page](./stack_machines.md)
### Creating and managing CONTAINERS
  * [configure a base server](./machine_configuration.md)
      * docker
      * git clone https://github.com/earthcube/geocodes.git
      * cd geocodes/deployment
      * setup domain names
      * create .env file
      * add  (traefik and portainer ) build-machine-compose.yaml
      * (add headless with larger shared memory) ./run_gleaner.sh   
  * [Use portainer to setup geocodes ](./setup_geocodes_containers.md)
      * add services-compose.yaml
      * add gecodes-compose.yaml

### Data Loading

* [Testing](indexing_with_gleanerio_for_testing.md(./))
* [Create a  'Production' config](./creatingProductionConfigs.md) 
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
