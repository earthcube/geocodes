# Notes on issues

## Creating Portainer and Traefik
 Initially thought to run the original stack in portainer.
 Did not work well. 
 
## Lets encrypt
When testing use the let's enxrypt developement server in the traefi.yml

Hit a limit during development where the acme.json was being created as a directory
Creating a config directory and telling let's encrypt/traefik proxy to store in that 
directory solved the issue. Still had to wait seven days for the limit to clear

## Container Building 
The docker container uses

`RUN npm build`

this calls

`vue-cli-service build`

Which run NODE_ENV production

added

`"geocodestest": "vue-cli-service build --mode geocodestest"`

and changed Dockerfile to
`RUN npm geocodestest`

This points out that the production container will need to just access a config.json 
file from a remote url.. or have it published into the containers
/public directory.

Headless:

Improving performance: 
I tried to replicated the headless container, but that make headless queries fail.

## healthcheck

https://medium.com/geekculture/how-to-successfully-implement-a-healthcheck-in-docker-compose-efced60bc08e


## Notes on updating a config from the command line
```
ubuntu@geocodes-dev:~$ docker stack services geocodes
ID             NAME                      MODE         REPLICAS   IMAGE                                      PORTS
qb2dg6kb3nsw   geocodes_notebook-proxy   replicated   1/1        nsfearthcube/mknb:latest                   
lo93ax3l4qp8   geocodes_vue-client       replicated   1/1        nsfearthcube/ec_facets_client:latest       
d1g5vckmivnj   geocodes_vue-services     replicated   1/1        nsfearthcube/ec_facets_api_nodejs:latest   
```

```shell
ubuntu@geocodes-dev:~$ docker stack services  --format="{{.ID}} {{.Name}}"  geocodes
qb2dg6kb3nsw geocodes_notebook-proxy
lo93ax3l4qp8 geocodes_vue-client
d1g5vckmivnj geocodes_vue-services
```

[How to stop a service](https://stackoverflow.com/questions/51102589/how-to-stop-a-docker-service)
docker service scale [servicename]=0

```shell
buntu@geocodes-dev:~$ docker service scale geocodes_vue-client=0
geocodes_vue-client scaled to 0
overall progress: 0 out of 0 tasks 
verify: Service converged 

```
