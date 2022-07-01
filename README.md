# geocodes
This is the containers stacks to run geocodes

Portainer:
 env files need to have extensions: .env

Note the server setup requires that you have some CNAMEs setup for 
the services. These are listed in hosts.geocodes


##  Setup a server:
### Overview:
* configure a base server
  * docker
  * git clone https://github.com/earthcube/geocodes.git
  * cd geocodes/deployment
  * setup domain names
  * create .env file
  * add  (traefik and portainer ) build-machine-compose.yaml
* Use portainer to setup geocodes
  * add services-compose.yaml
  * add gecodes-compose.yaml


## Setup for local
### Overview
