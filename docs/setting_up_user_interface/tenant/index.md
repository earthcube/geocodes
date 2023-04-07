# Setting up A Tenant
A 'tenant' will allow us to host a project with a separate UI, using common services

!!! warning "Assumptions"
    this assumes that the user is familiar with how the stack works

    * how to get a DNS name for the tenant
    * how to create datasource for minio and graph,
    * how to create a gleaner config file using glcon
    * how to  load data using glcon
    * how to create a facet_search.yaml  and load to docker/portainer config at config/facet_search+{project}
    * how to add a stack "geocodes_{project} in  portainer/docker


* a namepace for the graph and oss in the geocodes.services
* a client at thier DNS, eg. geoocdes.project.org

## Outline of the Steps:

* Setup
* Load Data
* Summarize
* Create Geocodes Client UI Stack

### Setup

* Choose a 'project' identifier, This will be an ENV variable ${GC_BASE} set in local environment, or portainer
* setup two namespaces in graph (see table below)
   * `project` - a quad store
   * `project_summary` - a triple store, full text index
* setup bucket in minio
   * `project`
* ask project to setup a DNS name for the client:
   * `geocodes.project.org CNAME geocodes-dev.earthcube.org`


| Item            | Name                             | This instance                                                                    |
|-----------------|----------------------------------|----------------------------------------------------------------------------------|
| project         | GC_BASE                          | if you are testing locally you can use an env variable, export GC_BASE={project} |
| DNS             | DNS HOST                         | geocodes.{dns}                                                                   |
| project graph   | graph.XXXX.XXX                   | {project}        (quad with full text)                                           |
| project summary | graph.XXXX.XXX                   | {project}_summary   (triples with full text)                                     |
| project bucket  | oss.xxxx.xxx                     | {project}                                                                        |
| config          | {on docker/portainer server xxx} | facets_config_{project}                                                          | 

### Load data
Load data Steps Overview:

* setup source
* glcon/gleaer/nabu
* init config
* edit localconfig.yaml
* generate config
* run gleaner
* run nabu
* run summary

#### create a config for the project, run and load data to the namespace and graph
  * data
    * add tab to the sources spreadsheet, use that location url
    * OR just use a local csv
  * `glcon config init --cfgName {project}`
  *  edit localConfig.yaml
    * `nano configs/{project}/localConfig.yaml`
  * `glcon config generate --cfgName {project}`

??? example "localConfig.yaml"
    ```yaml
    ---
    minio:
      address: oss.geocodes-dev.earthcube.org
      port: 443
      accessKey: {snip}
      secretKey: {snip}
      ssl: true
      bucket: {PROJECT} # can be overridden with MINIO_BUCKET
    sparql:
    #  endpoint: http://localhost/blazegraph/namespace/wifire/sparql
      endpoint: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/{PROJECT}/sparql
    s3:
      bucket: {PROJECT}  # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
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
### Run Glcon

* `glcon gleaner batch --cfgName {project}`
* `glcon nabu prefix --cfgName {project}`

### Run Summarize
[summarize](https://earthcube.github.io/earthcube_utilities/summarize/) materializes a flattend the graph 
* 
* Note this is new, undetested... take a look at the source if something breaks

* install earthcube summarize
* `pip3 install earthcube_summarize`
* [run summarize](https://earthcube.github.io/earthcube_utilities/summarize/#run-summarize_from_graph_namespace) (if installed via package, there should be a command line)
* `summarize_from_graph--repo {repo} --graphendpoint {endppiont} --summary_namespace {earthcube_summary}`



### Configure Client

If you may want to initially test with a local instance in an IDE.
After that this is the possible instructions for creating a tennant.


#### add a config in portainer (facets_config_{project})
    * using namespaces, minio and dns from above
??? example "config/facets_config_PROJECt"
    ```yaml
    ---
    #API_URL: http://localhost:3000
    API_URL: https://geocodes.{HOST}/ec/api
    TRIPLESTORE_URL: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/{PROJECT}/sparql
    SUMMARYSTORE_URL: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/{PROJECT}_summary/sparql
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

#### setup tenant stack
    * add a stack with project name  using  geocodes-compose_named.yaml
    * Before saving,  env var GC_BASE with project name


```shell
HOST=geocodes-dev.earthcube,org
FACET_SERVICES_FILE=./config/services.js
GC_CLIENT_DOMAIN=geocodes.{dns}
MINIO_ROOT_ACCESS_KEY={snip}
MINIO_ROOT_SECRET_KEY={snip}
MINIO_SERVICE_ACCESS_KEY={snip}
MINIO_SERVICE_SECRET_KEY={snip}
SPARQL_DEFAULT_SPARQL_ENDPOINT_PATH=/blazegraph/namespace/{PROJECT}/sparql
S3ADDRESS=oss.geocodes-dev.earthcube.org
S3KEY={snip}
S3SECRET={snip}
S3SSL=true
S3PORT=443
BUCKET={PROJECT}
BUCKETPATH=summoned
PATHTEMPLATE={{bucketpath}}/{{reponame}}/{{sha}}.jsonld
TOOLTEMPLATE={{bucketpath}}/{reponame}}/{{ref}}.json
TOOLBUCKET=ecrr
TOOLPATH=summoned
GC_GITHUB_SECRET={snip}
GC_GITHUB_CLIENTID={snip}
GC_NB_AUTH_MODE=service
GC_BASE=wifire
```
