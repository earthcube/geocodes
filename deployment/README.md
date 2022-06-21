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

### requirements:
* docker
* docker-compose

### To run:

Clone

cd deployment

LINUX
mkdir /tmp/gleaner
chmod 777 /tmp/gleaner

MAC:
CHANGE THE ENV LOCATION:

./run_geocodes.sh
