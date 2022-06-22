# Deployment of the Production Stack

This will be the geocodes stack for production, and needs to inlucde documentation.

The stack consists of several stacks, each with their own container.
* services-compose.yaml
  * treafik - a web router, like nginx
  * s3system - minio an s3 clone
  * graph - a triplestore, presently blazegraph
  * sparqlgui - a gui for sparql queries
* gecodes-compose.yam
  * vue-services - a nodejs express applicaiton that provides an api
  * vue-client - a vue application for the facet searching
  * notebook-proxy - a python flask application to create gists and run them as notebooks.
* geodex-compose.yml
  * dx - api
  * features - serve out of site

### requirements:
* docker
* docker-compose

Basic Steps to run locally:
* clone,
* change to deployment directory
* run a stack
  * ./run_geocodes.sh
  * ./run_geodex
* check Minio bucket configurations.
  * This could be done with a script (docker-compose run {some mc command})
* 
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
