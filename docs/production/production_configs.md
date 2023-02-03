
# Production configuration settings.
This is just a list of the customized sections of the 'production' configurations
You should be able to 'glean' information needed about what servers and sources are being utilized.


!!! note 
    You will need to customize these for each server.

| service      | config | servers                                                       | source                     |
|--------------| ----|---------------------------------------------------------------|----------------------------| 
| production   | geocodes | [geocodes-1](https://portainer.geocodes-1.earthcube.org/)     | production from  sources   |
| geocodes-dev | geocodes_all | [geocodes-dev](https://portainer.geocodes-dev.earthcube.org/) | sources from sources sheet |
| beta         | geocodes_all | [geocodes-dev](https://portainer.geocodes-dev.earthcube.org/) | sources from sources sheet |
| alpha        | geocodes_all |  [geocodes-1](https://portainer.geocodes-1.earthcube.org/)                                                    | sources from sources sheet |
| wifire       | wifire | [geocodes-dev](https://portainer.geocodes-dev.earthcube.org/) | wifire from sources sheet  |
** BETA AND ALPHA NEED TO BE UPDATED  to the latest tenant with updated configs and config/facet_search_{project} **

| service      |   servers      | notes                                                      |
|--------------| ----|------------------------------------------------------------|
| production   | geocodes-1   | Runs vetted Data                                           |
| geocodes-dev |  geocodes-dev | All sources                                                |
| beta         |  geocodes-dev | config/facets_serarch_beta point at geocodes-dev services? |
| alpha        |  geocodes-1   | config/facets_serarch_alpha pointed at geocodes-1 services |
| wifire       | gecodes-dev    | tenant                                                     |

** Alpha and Beta ** are user interface testing clients, so while tenants, they are using 
the data sources for production and gecodes-dev (all sources). These can be changed as needed.

!!! note "Production service naming logic"
    In order to better handle the ability to point the 'client' at different endpoints and services
    The new pattern is that the main server has a basename  that is not only 'geocodes'
    'geocodes-1' is the production service and it's services are affixed with geocodes-1.earthcube.org


# Production [geocodes.earthcube.org](https://geocodes.earthcube.org)
docker config: geocodes-1 configs/onfigs/facet_search

Production is a subset of the sources that have been vetted.

In order to better handle the ability to point the 'client' at different endpoints and services
The new pattern is that the main server has a basename  that is not only 'geocodes'
'geocodes-1' is the production service and it's services are affixed with geocodes-1.earthcube.org


environment
```shell
HOST=geocodes-1.earthcube.org
GLEANER_PORTAINER_DOMAIN=portainer.geocodes-1.earthcube.org
GLEANER_ADMIN_DOMAIN=admin.geocodes-1.earthcube.org
GLEANER_OSS_DOMAIN=oss.geocodes-1.earthcube.org
GLEANER_OSS_CONSOLE_DOMAIN=minioadmin.geocodes-1.earthcube.org
GLEANER_GRAPH_DOMAIN=graph.geocodes-1.earthcube.org
GLEANER_WEB_DOMAIN=web.geocodes-1.earthcube.org
GLEANER_SPARQLGUI_DOMAIN=sparqlui.geocodes.earthcube.org
GLEANER_GRAPH2_DOMAIN=graph2.geocodes-1.earthcube.org
GC_CLIENT_DOMAIN=geocodes.earthcube.org
GEODEX_BASE_DOMAIN=geodex.org
MINIO_ROOT_ACCESS_KEY={snip}
MINIO_ROOT_SECRET_KEY={snip}
MINIO_SERVICE_ACCESS_KEY=gleaner
MINIO_SERVICE_SECRET_KEY=addtoearthcube
FUSEKI_ADMIN_PASSWORD=earthcubeAdmin1!
GLEANER_TRAEFIK_YML=traefik_data
GLEANER_TRAEFIK=traefik_data
GLEANER_OBJECTS=minio
GLEANER_GRAPH=graph
SPARQL_DEFAULT_SPARQL_ENDPOINT_PATH=/blazegraph/namespace/earthcube/sparql
TRAEFIK_AUTH={snip}
GC_GITHUB_SECRET={snip}
GC_GITHUB_CLIENTID={snip}
GC_NB_AUTH_MODE=service
S3ADDRESS=oss.geocodes-1.earthcube.org
S3KEY=gleaner
S3SECRET=adtoearthcube
S3SSL=true
S3PORT=443
BUCKET=gleaner
BUCKETPATH=summoned
PATHTEMPLATE='${bucketpath}/${reponame}/${sha}.jsonld'
TOOLTEMPLATE='${bucketpath}/${reponame}/${ref}.json'
TOOLBUCKET=ecrr
TOOLPATH=summoned
```

localConfig.yaml
```yaml
---
minio:
  address: oss.geocodes-1.earthcube.org
  port: 443
  accessKey: {snip}
  secretKey: {snip}
  ssl: true
  bucket: gleaner # can be overridden with MINIO_BUCKET
sparql:
  endpoint: https://graph.geocodes-1.earthcube.org/blazegraph/namespace/earthcube/sparql
s3:
  bucket: gleaner # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
  domain: us-east-1

#headless field in gleaner.summoner
headless: http://127.0.0.1:9222
sourcesSource:
  type: csv
#  location: sources.csv
# this can be a remote csv
#  type: csv
  location: https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=TestSources202210
#  location: https://docs.google.com/spreadsheets/d/{key}/gviz/tq?tqx=out:csv&sheet={sheet_name}
# TBD -- Just use the sources in the gleaner file.
#  type: yaml
#  location: gleaner.yaml
```

config/facets_search
```yaml
---
#API_URL: http://localhost:3000
API_URL: https://geocodes.earthcube.org/ec/api
TRIPLESTORE_URL: https://graph.geocodes-1.earthcube.org/blazegraph/namespace/earthcube/sparql
SUMMARYSTORE_URL: https://graph.geocodes-1.earthcube.org/blazegraph/namespace/summary2/sparql
#SUMMARYSTORE_URL: https://graph.geodex.org/blazegraph/namespace/summary/sparql
ECRR_TRIPLESTORE_URL: http://132.249.238.169:8080/fuseki/ecrr/query
ECRR_GRAPH: http://earthcube.org/gleaner-summoned
THROUGHPUTDB_URL: https://throughputdb.com/api/ccdrs/annotations
SPARQL_QUERY: queries/sparql_query.txt
SPARQL_HASTOOLS: queries/sparql_hastools.txt
SPARQL_TOOLS_WEBSERVICE: queries/sparql_gettools_webservice.txt
SPARQL_TOOLS_DOWNLOAD: queries/sparql_gettools_download.txt
JSONLD_PROXY: https://geocodes.geocodes-1.earthcube.org/ec/api/${o}
SPARQL_NB: https://geocodes.earthcube.org/notebook/mkQ?q=${q}
SPARQL_YASGUI: https://sparqlui.geocodes.earthcube.org/?
```

----------
-------------
## Geocodes-dev/staging  [geocodes.geocodes-dev.earthcube.org](https://geocodes.geocodes-dev.earthcube.org) 
docker config: geocodes-dev configs/facet_search

This would be a list of all sources and sitemaps.

environment
```shell
HOST=geocodes-1.earthcube.org
FACET_SERVICES_FILE=./config/services.js
GC_CLIENT_DOMAIN=alpha.geocodes.earthcube.org
MINIO_ROOT_ACCESS_KEY={snip}
MINIO_ROOT_SECRET_KEY={snip}
MINIO_SERVICE_ACCESS_KEY={snip}
MINIO_SERVICE_SECRET_KEY={snip}
SPARQL_DEFAULT_SPARQL_ENDPOINT_PATH=/blazegraph/namespace/earthcube/sparql
S3ADDRESS=oss.geocodes-1.earthcube.org
S3KEY=worldsbestaccesskey
S3SECRET=worldsbestsecretkey
S3SSL=true
S3PORT=443
BUCKET=gleaner
BUCKETPATH=summoned
PATHTEMPLATE={{bucketpath}}/{{reponame}}/{{sha}}.jsonld
TOOLTEMPLATE={{bucketpath}}/{{reponame}}/{{ref}}.json
TOOLBUCKET=ecrr
TOOLPATH=summoned
GC_GITHUB_SECRET={snip}
GC_GITHUB_CLIENTID={snip}
GC_NB_AUTH_MODE=service
GC_BASE=gcalpha
```

localConfig.yaml
```yaml
---
minio:
  address: oss.geocodes-dev.earthcube.org
  port: 443
  accessKey: {snip}
  secretKey: {snip}
  ssl: true
  bucket: gleaner # can be overridden with MINIO_BUCKET
sparql:
  endpoint: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/earthcube/sparql
s3:
  bucket: gleaner # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
  domain: us-east-1

#headless field in gleaner.summoner
headless: http://127.0.0.1:9222
sourcesSource:
  type: csv
  #  location: sources.csv
  location: https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=sources
# this can be a remote csv
#  type: csv
#  location: https://docs.google.com/spreadsheets/d/{key}/gviz/tq?tqx=out:csv&sheet={sheet_name}
# TBD -- Just use the sources in the gleaner file.
#  type: yaml
#  location: gleaner.yaml

```

facets_search.yaml
```yaml
---
#API_URL: http://localhost:3000
API_URL: https://geocodes.geocodes-dev.earthcube.org/ec/api
TRIPLESTORE_URL: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/earthcube/sparql
SUMMARYSTORE_URL: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/summary/sparql
ECRR_TRIPLESTORE_URL: http://132.249.238.169:8080/fuseki/ecrr/query
ECRR_GRAPH: http://earthcube.org/gleaner-summoned
THROUGHPUTDB_URL: https://throughputdb.com/api/ccdrs/annotations
SPARQL_QUERY: queries/sparql_query.txt
SPARQL_HASTOOLS: queries/sparql_hastools.txt
SPARQL_TOOLS_WEBSERVICE: queries/sparql_gettools_webservice.txt
SPARQL_TOOLS_DOWNLOAD: queries/sparql_gettools_download.txt
JSONLD_PROXY: https://geocodes.geocodes-dev.earthcube.org/ec/api/${o}
# oauth issues. need to add another auth app for additional 'proxies'
SPARQL_NB: https://geocodes.earthcube.org/notebook/mkQ?q=${q}
SPARQL_YASGUI: https://sparqlui.geocodes-dev.earthcube.org/?
```


-------------

## wifire
docker config: geocodes-dev   configs/wifire

environment
```shell
HOST=geocodes-dev.earthcube,org
FACET_SERVICES_FILE=./config/services.js
GC_CLIENT_DOMAIN=geocodes.wifire-data.sdsc.edu
MINIO_ROOT_ACCESS_KEY={snip}
MINIO_ROOT_SECRET_KEY={snip}
MINIO_SERVICE_ACCESS_KEY={snip}
MINIO_SERVICE_SECRET_KEY={snip}
SPARQL_DEFAULT_SPARQL_ENDPOINT_PATH=/blazegraph/namespace/wifire/sparql
S3ADDRESS=oss.geocodes-dev.earthcube.org
S3KEY={snip}
S3SECRET={snip}
S3SSL=true
S3PORT=443
BUCKET=wifire
BUCKETPATH=summoned
PATHTEMPLATE={{bucketpath}}/{{reponame}}/{{sha}}.jsonld
TOOLTEMPLATE={{bucketpath}}/{reponame}}/{{ref}}.json
TOOLBUCKET=ecrr
TOOLPATH=summoned
GC_GITHUB_SECRET=OAUTH SECRET
GC_GITHUB_CLIENTID=OAUTH APP ID
GC_NB_AUTH_MODE=service
GC_BASE=wifire
```

localConfig.yaml
```yaml
---
minio:
  address: oss.geocodes-dev.earthcube.org
  port: 443
  accessKey: {snip}
  secretKey: {snip}
  ssl: true
  bucket: wifire # can be overridden with MINIO_BUCKET
sparql:
#  endpoint: http://localhost/blazegraph/namespace/wifire/sparql
  endpoint: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/wifire/sparql
s3:
  bucket: wifire # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
  domain: us-east-1

#headless field in gleaner.summoner
headless: http://127.0.0.1:9222
sourcesSource:
  type: csv
  location:  https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=wifire
# this can be a remote csv
#  type: csv
#  location: https://docs.google.com/spreadsheets/d/{key}/gviz/tq?tqx=out:csv&sheet={sheet_name}
# TBD -- Just use the sources in the gleaner file.
#  type: yaml
#  location: gleaner.yaml

```

config/facets_config_wifire 
```yaml
---
#API_URL: http://localhost:3000
API_URL: https://geocodes.wifire-data.sdsc.edu/ec/api
#TRIPLESTORE_URL: https://graph.geodex.org/blazegraph/namespace/earthcube/sparql
TRIPLESTORE_URL: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/wifire/sparql
SUMMARYSTORE_URL: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/wifire_summary/sparql
#SUMMARYSTORE_URL: https://graph.geodex.org/blazegraph/namespace/summary/sparql
ECRR_TRIPLESTORE_URL: http://132.249.238.169:8080/fuseki/ecrr/query
ECRR_GRAPH: http://earthcube.org/gleaner-summoned
THROUGHPUTDB_URL: https://throughputdb.com/api/ccdrs/annotations
SPARQL_QUERY: queries/sparql_query.txt
SPARQL_HASTOOLS: queries/sparql_hastools.txt
SPARQL_TOOLS_WEBSERVICE: queries/sparql_gettools_webservice.txt
SPARQL_TOOLS_DOWNLOAD: queries/sparql_gettools_download.txt
JSONLD_PROXY: "${window.location.origin}/ec/api/${o}"
# oauth issues. need to add another auth app for additional 'proxies'
# This is the one that will work: SPARQL_NB: https://geocodes.earthcube.org/notebook/mkQ?q=${q}
SPARQL_NB: https://geocodes.earthcube.org/notebook/mkQ?q=${q}
####
SPARQL_YASGUI: https://sparqlui.geocodes-dev.earthcube.org/?
```



-------------
## Alpha **needs to be updated** - [alpha.geocodes.earthcube.org](https://alpha.geocodes.earthcube.org)

This would be a list of all sources and sitemaps.

environment
```shell
HOST=geocodes-1.earthcube.org
FACET_SERVICES_FILE=./config/services.js
GC_CLIENT_DOMAIN=alpha.geocodes.earthcube.org
MINIO_ROOT_ACCESS_KEY={snip}
MINIO_ROOT_SECRET_KEY={snip}
MINIO_SERVICE_ACCESS_KEY={snip}
MINIO_SERVICE_SECRET_KEY={snip}
SPARQL_DEFAULT_SPARQL_ENDPOINT_PATH=/blazegraph/namespace/earthcube/sparql
S3ADDRESS=oss.geocodes-1.earthcube.org
S3KEY=worldsbestaccesskey
S3SECRET=worldsbestsecretkey
S3SSL=true
S3PORT=443
BUCKET=gleaner
BUCKETPATH=summoned
PATHTEMPLATE={{bucketpath}}/{{reponame}}/{{sha}}.jsonld
TOOLTEMPLATE={{bucketpath}}/{{reponame}}/{{ref}}.json
TOOLBUCKET=ecrr
TOOLPATH=summoned
GC_GITHUB_SECRET={snip}
GC_GITHUB_CLIENTID={snip}
GC_NB_AUTH_MODE=service
GC_BASE=gcalpha
```

localConfig.yaml
```yaml
---
minio:
  address: oss.geocodes-1.earthcube.org
  port: 443
  accessKey: {snip}
  secretKey: {snip}
  ssl: true
  bucket: gleaner # can be overridden with MINIO_BUCKET
sparql:
  endpoint: https://graph.geocodes-1.earthcube.org/blazegraph/namespace/earthcube/sparql
s3:
  bucket: gleaner # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
  domain: us-east-1

#headless field in gleaner.summoner
headless: http://127.0.0.1:9222
sourcesSource:
  type: csv
#  location: sources.csv
# this can be a remote csv
#  type: csv
  location: https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=sources
#  location: https://docs.google.com/spreadsheets/d/{key}/gviz/tq?tqx=out:csv&sheet={sheet_name}
# TBD -- Just use the sources in the gleaner file.
#  type: yaml
#  location: gleaner.yaml

```

facets_search.yaml
```yaml

```
