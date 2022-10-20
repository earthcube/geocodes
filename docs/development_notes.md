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
