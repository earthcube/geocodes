##  Setup Machine:
Container services
* docker
* DNS hosting of machine names
* creating a set of base containers so that we have an http proxy and container user interface
* Adding "Stacks" for services, and geocodes

# setup domain names

   [Machines]( stack_machines.md )
   [Name for remote DNS](../deployment/hosts.geocodes)
   [Name for local DNS](../deployment/hosts.geocodes-local)
## create a machine in openstack 
or other host



## configure a base server
  * add docker, git
  * git clone https://github.com/earthcube/geocodes.git
  * cd geocodes/deployment
  * copy env.example, to {myhost}.env
     * modify the file
     * lets encrypt, 
       * set to use dev server while testing
     * 
  * start the base containers 
    * ./run_base.sh
  * Are containers running
    * `docker ps`
  * Is network setup correctly
    * `docker network ls`
  * Are volumes available
    * `docker volumes`
      * 
  * available via the web
    * https://admin.{host}
      * login is admin:iforget
    * https://portainer.{host}/
      * this will ask you to setup and admin password


## How tos needed:
* LOCAL DNS SETUP
  * editing hosts does not work with letsencrypt. If user has a local name server they control, that might work
  * 
* setup a new password for traefik
* lets encrypt
