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

`sudo apt install docker.io`
`sudo apt-get install docker-compose-plugin`

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


from the iner.geocodes-dev.earthcube.org/
add environment

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
portainer/agent:2.16.1
