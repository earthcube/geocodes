##  Setup Machine:

[TOC]

# Services:
This is what will be needed to create a production server

* base virtual machine for containers
* ability to request DNS,


!!! warning "DOCKER REQUIREMENT"
    If you are running on Ubuntu, you need to remove the provided docker.com version. [Official docker package](https://docs.docker.com/engine/install/ubuntu/)
    We suggest that for others, confirm that you can run 

    ```shell
    docker compose version
    Docker Compose version v2.13.0
    ```

    If you cannot run `docker compose` then update to the docker.com version
    This is the version we are presently running.

    ```    
    Client: Docker Engine - Community
         Version:           20.10.21
         API version:       1.41
    ```


--- 
### Steps:

* create a machine in openstack (if production)
  * select size
  * associate floating IP
    * ask for DNS for that ip to be configured with needed names
* ssh to machine. You do not need to have the DNS's to install the software. But it will be needed.
  * update apt
    * `sudo apt update`
  * update base software
    * `sudo apt upgrade`

  * install docker
    *   **use these docker install** [instructions](https://docs.docker.com/engine/install/ubuntu/)
  * add ubuntu to docker group
    * `sudo groupadd docker`
    * `sudo usermod -aG docker ubuntu`
  * reboot
    * `sudo reboot now`
  * init docker swarm
    * `docker swarm init`
  * verify proper base configuration
    * docker compose --help shows a -p flag
* SNAPSHOT and creaate an image
  * 
* clone geocodes
* `git clone https://github.com/earthcube/geocodes.git`
* configure a base server
* take a break and wait for the DNS entries.
  * if you cant wait you can go to the no cert port 
    * https://{HOST}}:9443/
    * use chrome, click advanced, and go to the port.


---
## create a machine in openstack

!!! info "Suggested size:"
    SDSC Openstack:

    - ubuntu 22
    - 100 gig
        - m1.2xlarge (8 CPU, 32 gig)
        - network: earthcube
    -  Security groups:
        - remote ssh (22)
        - geocodes (http/https; 80:443)
        - portainer (temporary need: 9443)
        - minio (optional: 9000/9001)
    - Keypair: earthcube (or any)


!!! tip "Ports Pre-DNS"
    minio ports do not need to be open, we are proxying on 80 and 443
    Portainer port (9443)  can be opended temporarily if you want to play a bit pre-DNS.

!!! success "Associate a Public IP"
    After the machine is created, we can change the IP to the one associated with geocodes.earthcube.org

---
# setup domain names
* [Machines]( stack_machines.md )
*   [Name for remote DNS](https://raw.githubusercontent.com/earthcube/geocodes/main/deployment/hosts.geocodess)

!!! warning "ESSENTIAL for PRODUCTION"
    It is ESSENTIAL for PRODUCTION that the names are defined in a DNS. This allows for https for all services
    and some services (aka s3/minio) do not play well with a proxy.


You might be able to run production stack using localhost, with these DNS...
but that mucks with the lets encrypt HTTPS certs... if you control your own DNS, these are the 
entries needed.  [Name for local DNS](https://raw.githubusercontent.com/earthcube/geocodes/main/deployment/hosts.geocodes-local)

[Local testing and development](local_developer/index.md) can be using  the local compose configuration. This use http, and 
local ports for services that cannot be proxied

---

## ssh to machine and verify

`ssh -i ~/.ssh/earthcube.pem ubuntu@{public IP}`


---

# configure a base server

* add docker, git
    *   **use these docker install** [instruction](https://docs.docker.com/engine/install/ubuntu/)
* git clone https://github.com/earthcube/geocodes.git
* cd geocodes/deployment
* copy  base_machine.example.env, to .env
    * modify the file
    * note: you can also copy the full portainer.env. 
* modify the treafik-data/traefik.yml

??? example "treafik-data/traefik.yml"
    ```{ .yaml .copy }    
    acme:
    # using staging for testing/development
    #     caServer: https://acme-staging-v02.api.letsencrypt.org/directory
        email: example@earthcube.org
        storage: acme.json
        httpChallenge:
            entryPoint: http
    ```
    If production, comment the line as shown. Developers see Lets Encypt Notes 

??? note "Let Encrypt Notes"
    [lets encrypt](https://doc.traefik.io/traefik/https/acme/), 
   
    (developers) set to use [staging environment](https://letsencrypt.org/docs/staging-environment/) server while testing
    If you are doing development, then leave the caServer uncommented.
 


     
# start the base containers 

* new machine or developer
  * `./run_base.sh -e {your environment file}`
* **production**: this uses the default .env (cp  portainer.env .env)
??? example "`./run_base.sh`"
    ```shell     
          ubuntu@geocodes-dev:~/geocodes/deployment$ ./run_base.sh -e geocodes-1.env
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
 
??? example "`docker ps`" 
    ```shell
        * ubuntu@geocodes-dev:~/geocodes/deployment$ docker ps
          CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS                                                                      NAMES
          09a5d8683cce   traefik:v2.4                    "/entrypoint.sh trae…"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   traefik
          d3e2333ade6f   portainer/portainer-ce:latest   "/portainer"             2 minutes ago   Up 2 minutes   8000/tcp, 9000/tcp, 9443/tcp                                               portainer
    ```

* Is network setup correctly?
 
??? example "`docker network ls`"
    ```shell
    docker network ls
          NETWORK ID     NAME              DRIVER    SCOPE
          ad6cbce4ec60   bridge            bridge    local
          2f618fa7da6d   docker_gwbridge   bridge    local
          f8048bc7a3d9   host              host      local
          kibdi510bt0x   ingress           overlay   swarm
          12c01a2186b0   none              null      local
          u4d4oxfy7olc   traefik_proxy     overlay   swarm
    ```
    ???? note
       NAME:traefik_proxy needs to exist, and be DRIVER:overlay, SCOPE:swarm

* Are volumes available

??? example "`docker volumes`"
    ```shell
    ubuntu@geocodes-dev:~$ docker volume ls
          DRIVER    VOLUME NAME
          local     graph
          local     minio
          local     portainer_data
          local     traefik_data
    ```

## is the base running?
  * are Traefik and Portainer available via the web?
    * **Treafik** https://admin.{host}
      * login is admin:iforget
  ![Traefik_admin](./images/traefik_admin.png)
    * **Portainer** https://portainer.{host}/
      * this will ask you to setup and admin password
![Portainer](./images/portainer_home.png)

## How tos needed:
* LOCAL DNS SETUP
  * editing your local machine /etc/hosts file does not work with letsencrypt. 
  * If user has a local name server they control, that might work.
* setup a new password for traefik
* lets encrypt

## updating Portainer, or treafik

the latest image needs to bb pulled

`docker pull portainer/portainer-ce:latest`

then 
`./run_base.sh`

----
## SSH 

for production, we recccomend that you use a group account/main account

to do this you will need to create and copy a public/private key

Generate an ssh-key:

```
ssh-keygen -t rsa -b 4096 -C "comment"
```

copy it to your remote server:

```
ssh-copy-id user@ip
```

or you can manually copy the 
```~/.ssh/id_rsa.pub to ~/.ssh/authorized_keys.```

Edit

It can be done through ssh command as mentioned @chepner:

```
ssh user@ip 'mkdir ~/.ssh'
ssh user@ip 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
```
(Above based on: [stackexchange](https://unix.stackexchange.com/questions/630186/how-to-add-ssh-keys-to-a-specific-user-in-linux))
