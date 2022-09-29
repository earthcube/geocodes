# Documentation for the Geocodes Container Stack

Table of Contents here


### Overview:
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

* [Create a 'Production' config](./creatingProductionConfigs.md)

* [Testing](indexing_with_gleanerio_for_testing.md(./))

