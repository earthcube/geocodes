# intial notes on setting up a docker swarm on aws

## create virutal machine
* Kevin did this
** user earthcube: sent key
* 
## login, install docker
earthcube@ip-172-31-9-0:~$ docker
```
Command 'docker' not found, but can be installed with:
snap install docker         # version 20.10.17, or
apt  install docker.io      # version 20.10.21-0ubuntu1~22.04.2
apt  install podman-docker  # version 3.4.4+ds1-1ubuntu1`
See 'snap info docker' for additional versions.
```

**This is the wrong command**

If you are running on **Ubuntu**, you need to remove the provided docker.com version. [Official docker package](https://docs.docker.com/engine/install/ubuntu/)
We suggest that for others, confirm that you can run



Follow the [official docker](https://docs.docker.com/engine/install/ubuntu/) as noted in the docs
and the linux post isntall

```shell
sudo groupadd docker
sudo usermod -aG docker earthcube

```

Log in and out

```shell
docker info 
```

sudo systemctl enable docker.service
sudo systemctl enable containerd.service


docker swarm init --advertise-addr 54.244.44.10


from the portainter.geocodes-dev.earthcube.org/
add environment **Docker Swarm**

USE THE INTERNAL AMAZON IP ADDRESS, else you will need to open port 9001... 

docker network create \
--driver overlay \
portainer_agent_network

docker service create \
--name portainer_agent \
--network portainer_agent_network \
-p 9001:9001/tcp \
--mode global \
--constraint 'node.platform.os == linux' \
--mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
--mount type=bind,src=//var/lib/docker/volumes,dst=/var/lib/docker/volumes \
portainer/agent:2.18.4


## configure portainer
### Test... 
do you have a the DNS setup properly.
try

`nslookup admin.{HOST}`

### Add in portainer interface 
* network :  
  * traefik_proxy (overlay)
  *   headless_gleanerio(overlay)
* volumes: log,   traefik_data
* configuration: 
  * gleaner
   * nabu
  * treafik.yml
   please change the email address 
  
```yaml
api:
  dashboard: true

entryPoints:
  http:
    address: ":80"
  https:
    address: ":443"

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false

certificatesResolvers:
  httpresolver:
    acme:
      # using staging for testing/development
      #caServer: https://acme-staging-v02.api.letsencrypt.org/directory
      email: dwvalentine@ucsd.edu
      storage: /etc/traefik/acme.json
      httpChallenge:
        entryPoint: http
  httpresolver_staging:
    acme:
      # using staging for testing/development
      caServer: https://acme-staging-v02.api.letsencrypt.org/directory
      email: dwvalentine@ucsd.edu
      storage: /etc/traefik/acme.json
      httpChallenge:
        entryPoint: http
  httpresolver_production:
    acme:
      # using staging for testing/development
      #caServer: https://acme-staging-v02.api.letsencrypt.org/directory
      email: dwvalentine@ucsd.edu
      storage: /etc/traefik/acme.json
      httpChallenge:
        entryPoint: http

```

!!! Warn
    this needs to deploy a headleass, and the configs for gleaner and nabu, .
* stack: headless
    * https://github.com/earthcube/geocodes.git
    * deployment/gleaner-compose.yaml
    * env variables
``` yaml
     HOST=
```

* Then configure dagit in portainer hosting dagster.
get the porteiner endpoint correct
```shell
PORTAINER_URL=https://portainer.geocodes-aws-dev.earthcube.org:443/api/endpoints/9/docker/
```

will need notes on securing it to a user, with that users API key

[//]: # (* stack: )

[//]: # (   * https://github.com/earthcube/geocodes.git)

[//]: # (   * deployment/base-swarm-compose.yaml)

[//]: # (   * env variables)

[//]: # (``` yaml)

[//]: # (     GLEANER_ADMIN_DOMAIN=admin.geocodes-data-loader.earthcube.org)

[//]: # (     GLEANER_SPARQLGUI_DOMAIN=sparqlgui.geocodes-data-loader.earthcube.org)

[//]: # (```)

[//]: # ()
[//]: # (* check GLEANER_ADMIN_DOMAIN  https://{GLEANER_ADMIN_DOMAIN} )
