# Setting up Geocodes Services on AWS

To do this, we are going to utilize four pieces:
* s3, replaces Minio Container
* neptune, replaces Graph Container
* single virutal machine setup as a docker storm.
* Portainer setup on in Our Openstack.

Major differences in the docker:
* uses config to store traefik config
* use a volume to store the trafikl

## Notes on Setting up s3 and Neptune

## Docker stack
Install docker stack setup as the base machine install where 
` docker stack init --address--`

### From Console
1. setup netowrk
1. setup volumes
1. setup config
2. setup secrets
3. 

`volume create traefik_data`
`volume create logs`

`docker network create -d overlay --attachable traefik_proxy`

`docker config create   traefik_yml ./traefik-aws/traefik.yml`

docker secret create 


S3SSL=true
S3PORT=443

MINIO_ROOT_ACCESS_KEY=worldsbestaccesskey
MINIO_ROOT_SECRET_KEY=worldsbestsecretkey
#MINIO_SERVICE_ACCESS_KEY=worldsbestaccesskey
#MINIO_SERVICE_SECRET_KEY=worldsbestsecretkey

GC_GITHUB_SECRET=OAUTH SECRET
GC_GITHUB_CLIENTID=OAUTH APP ID
GC_NB_AUTH_MODE=service
# a user api key.  All gists are stored in this users account
#GC_GITHUB_USER=USER
#GC_GITHUB_TOKEN=ghp_KEY
#GC_NB_AUTH_MODE=apikey


###  setup stack in portainer

1. edit the portainer_aws.env
1. copy over the base-aws-compose.yaml

  1. or use the git version
```
Name: base
Build method: git repository
Repository URL: https://github.com/earthcube/geocodes
Reference: refs/heads/main
Compose path: dbase-aws-compose.yaml
```



## Notes:

https://enginaltay.medium.com/how-to-use-traefik-as-ingress-router-on-aws-fc559f87f4d8
