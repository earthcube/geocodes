# Deployment of the Production Stack

This will be the geocodes stack for production, and needs to inlucde documentation.

The stack consists of several stacks, each with their own container.
* services-compose.yaml
  * treafik - a web router, like nginx
  * s3system - minio an s3 clone
  * graph - a triplestore, presently blazegraph
  * sparqlgui - a gui for sparql queries
* gecodes-compose.yaml
  * vue-services - a nodejs express applicaiton that provides an api
  * vue-client - a vue application for the facet searching
  * notebook-proxy - a python flask application to create gists and run them as notebooks.
* geodex-compose.yaml
  * dx - api
  * features - serve out of site

### requirements:
* docker 
   * _docker compose_  we have had issues with older versions of docker and docker-compose. If you cannot run `docker compose` then update
   * this is what we are running, at present.
```    
Client: Docker Engine - Community
     Version:           20.10.21
     API version:       1.41
```
  
If you are running on Ubuntu, you need to remove the provided docker.com version. instruction](https://docs.docker.com/engine/install/ubuntu/)
We suggest that for others, also. 
 

**Local Developement:**
DNS at present is important. We route on using Treafik using DNS names, so we develop on container hosted, and not local developers.

* add lines for hosts.geocodes to /etc/hosts
* mac
  * sudo dscacheutil -flushcache
* linux:
  * 
Basic Steps to run locally:
* clone,
* change to deployment directory
* create a .env file from the env.example
  * modify the variables, as needed.
  * create a password for traefik admin
    * `echo $(htpasswd -nb admin 1forget) | sed -e s/\\$/\\$\\$/g`
* run a stack
  * ./run_geocodes.sh
  * ./run_geodex.sh (when doing a production)
* see if you can get to admin.local.dev
  * password for the treafik admin is: admin:1forgetit
* If you can, then are all the routes working.
* log onto
  * https://minioadmin.local.dev
    * configurue buckets
    * service* check Minio bucket configurations.
    * gleaner, forms, sites buckets,
    * add a service account with the and put infomration in these keys:
      * MINIO_SERVICE_ACCESS_KEY=worldsbestaccesskey
        MINIO_SERVICE_SECRET_KEY=worldsbestsecretkey
    * This could be done with a script (*docker-compose run {some mc command})
* log onto
  * https://geocodes.local.dev
  * test ui
* run glcon to popuplate buckets

### To run:

Clone

cd deployment

#### Configure Environment files

##### LINUX

```
mkdir /tmp/gleaner
chmod 777 /tmp/gleaner
```

##### MAC:

Minio cannot run out of the tmpfs on a mac.
CHANGE THE ENV LOCATION:


`./run_geocodes.sh`

### Minio buckets config

For Geodex: sites, geodex, gleaner

For Geocodes: sites, gleaner, forms
