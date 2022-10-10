##  Setup Machine:
Container services
* docker
* DNS hosting of machine names
* creating a set of base containers so that we have an http proxy and container user interface
  * add a headless with a large shared memory ./run_gleaner.sh
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
  * modify the treafik-data/traefik.yml
     *  [lets encrypt](https://doc.traefik.io/traefik/https/acme/), 
        * (developers) set to use [staging environment](https://letsencrypt.org/docs/staging-environment/) server while testing
```    
   acme:
      # using staging for testing/development
 #     caServer: https://acme-staging-v02.api.letsencrypt.org/directory
      email: example@earthcube.org
      storage: acme.json
      httpChallenge:
        entryPoint: http
```
     
  * start the base containers 
    * developer
      * ./run_base.sh -e {your environment file}
    * production: this uses the default portainer.env
      * ./run_base.sh 
```      
      ubuntu@geocodes-dev:~/geocodes/deployment$ ./run_base.sh
      Error response from daemon: network with name traefik_proxy already exists
      NETWORK ID     NAME              DRIVER    SCOPE
      ad6cbce4ec60   bridge            bridge    local
      2f618fa7da6d   docker_gwbridge   bridge    local
      f8048bc7a3d9   host              host      local
      kibdi510bt0x   ingress           overlay   swarm
      12c01a2186b0   none              null      local
      u4d4oxfy7olc   traefik_proxy     overlay   swarm
      Verify that the traefik_proxy network SCOPE is swarm
      traefik_data
      portainer_data
      true
      [+] Running 2/2
      ⠿ Container portainer  Started                                           13.7s
      ⠿ Container traefik    Started
```
      
  * Are containers running
    * `docker ps`
```
    * ubuntu@geocodes-dev:~/geocodes/deployment$ docker ps
      CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS                                                                      NAMES
      09a5d8683cce   traefik:v2.4                    "/entrypoint.sh trae…"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   traefik
      d3e2333ade6f   portainer/portainer-ce:latest   "/portainer"             2 minutes ago   Up 2 minutes   8000/tcp, 9000/tcp, 9443/tcp                                               portainer
```
  * Is network setup correctly?
    * `docker network ls`
```      docker network ls
      NETWORK ID     NAME              DRIVER    SCOPE
      ad6cbce4ec60   bridge            bridge    local
      2f618fa7da6d   docker_gwbridge   bridge    local
      f8048bc7a3d9   host              host      local
      kibdi510bt0x   ingress           overlay   swarm
      12c01a2186b0   none              null      local
      u4d4oxfy7olc   traefik_proxy     overlay   swarm
```
NAME:traefik_proxy needs to exist, and be DRIVER:overlay, SCOPE:swarm

  * Are volumes available
    * `docker volumes`
```     ubuntu@geocodes-dev:~$ docker volume ls
      DRIVER    VOLUME NAME
      local     graph
      local     minio
      local     portainer_data
      local     traefik_data
```

### is the base running?
  * are Traefik and Portainer available via the web?
    * **Treafik** https://admin.{host}
      * login is admin:iforget
  ![Traefik_admin](./images/traefik_admin.png)
    * **Portainer** https://portainer.{host}/
      * this will ask you to setup and admin password
![Portainer](./images/portainer_home.png)

## How tos needed:
* LOCAL DNS SETUP
  * editing hosts does not work with letsencrypt. If user has a local name server they control, that might work
* setup a new password for traefik
* lets encrypt
