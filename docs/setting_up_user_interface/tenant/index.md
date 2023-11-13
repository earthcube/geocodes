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

* example "localConfig.yaml"
    ```yaml
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
* Note this is new, untested... take a look at the source if something breaks
* install earthcube summarize
* `pip3 install earthcube_summarize`
* [run summarize](https://earthcube.github.io/earthcube_utilities/summarize/#run-summarize_from_graph_namespace) (if installed via package, there should be a command line)
* `summarize_from_graph--repo {repo} --graphendpoint {endppiont} --summary_namespace {earthcube_summary}`
* (Optional) Upload the output file to graph if you haven't. You can check whether the file exists by checking:
  * https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/{PROJECT}/sparql

### Configure Client

If you may want to initially test with a local instance in an IDE.
After that this is the possible instructions for creating a tenant.

* setup a stack on portainer
  * go to Stacks/Repository
  * fill out the section Git repository
  * add a stack with project name using geocodes-compose-named.yaml
  * you can use advanced mode for easier editting the config 
  * before saving, modify GC_BASE with project name
  * deploy it

```text
Name: geocodes
Build method: git repository
Repository URL: https://github.com/earthcube/geocodes
reference: refs/heads/main
Compose path: deployment/geocodes-compose-named.yaml
```

```shell
HOST=geocodes.ncsa.illinois.edu
FACETS_CONFIG_CONFIG=facets_config_prod
FACET_SERVICES_FILE=./config/services.js
GC_CLIENT_DOMAIN=production.geocodes.ncsa.illinois.edu
MINIO_ROOT_ACCESS_KEY=
MINIO_ROOT_SECRET_KEY=
MINIO_SERVICE_ACCESS_KEY=
MINIO_SERVICE_SECRET_KEY=
SPARQL_DEFAULT_SPARQL_ENDPOINT_PATH=/blazegraph/namespace/citest/sparql
S3ADDRESS=oss.geocodes.ncsa.illinois.edu
S3KEY=
S3SECRET=
S3SSL=true
S3PORT=443
BUCKET=earthcube
BUCKETPATH=summoned
PATHTEMPLATE={{bucketpath}}/{{reponame}}/{{sha}}.jsonld
TOOLTEMPLATE={{bucketpath}}/{reponame}}/{{ref}}.json
TOOLBUCKET=ecrr
TOOLPATH=summoned
GC_GITHUB_SECRET={snip}
GC_GITHUB_CLIENTID={snip}
GC_NB_AUTH_MODE=service
GC_BASE=NCSA-production
URIVERSION=v2
```

* add a config in portainer (facets_config_{project}) (go to Configs on portainer)
  * using namespaces, minio and dns from above
  * example for "config/facets_config_PROJECT"
```yaml
# https://geocodes.earthcube.org
API_URL: https://production.geocodes.ncsa.illinois.edu/ec/api
# local development
#API_URL: "${window_location_origin}/ec/api"
S3_REPORTS_URL: https://oss.geocodes.ncsa.illinois.edu/earthcube/reports/
TRIPLESTORE_URL: https://graph.geocodes.ncsa.illinois.edu/blazegraph/namespace/earthcube/sparql
SUMMARYSTORE_URL: https://graph.geocodes.ncsa.illinois.edu/blazegraph/namespace/earthcube_summary/sparql
BLAZEGRAPH_TIMEOUT: 20
# JSONLD_PROXY needs qoutes... since it has a $
JSONLD_PROXY: "https://production.geocodes.ncsa.illinois.edu/ec/api/${o}"
# oauth issues. need to add another auth app for additional 'proxies'
# This is the one that will work: SPARQL_NB: https://geocodes.earthcube.org/notebook/mkQ?q=${q}
SPARQL_NB: https://geocodes.ncsa.illinois.edu/notebook/mkQ?q=${q}
SPARQL_YASGUI: https://sparqlui.geocodes.ncsa.illinois.edu/?

## ECRR need to use fuseki source, for now.
ECRR_TRIPLESTORE_URL: http://132.249.238.169:8080/fuseki/ecrr/query
ECRR_GRAPH: http://earthcube.org/gleaner-summoned
######
# Less common modifications needed
######
THROUGHPUTDB_URL: https://throughputdb.com/api/ccdrs/annotations
SPARQL_QUERY: queries/sparql_query.txt
SPARQL_HASTOOLS: queries/sparql_hastools.txt
SPARQL_TOOLS_WEBSERVICE: queries/sparql_gettools_webservice.txt
SPARQL_TOOLS_DOWNLOAD: queries/sparql_gettools_download.txt
#####
# Not common to need to edit below
###

COLLECTION_FACETS:
  - field: unassigned
    title: All Items
    sort: acs
    open: false
    type: unassigned
    collections:
      - data
      - query
      - tool
    items:
      - id: data
        count: 0
        isActive: false
        name: data
      - id: query
        count: 0
        isActive: false
        name: query
      - id: tool
        count: 0
        isActive: false
        name: tool
  - field: all
    title: All Collections
    sort: acs
    open: false
    type: all
    collections:
      - data
      - query
      - tool
    items:
      - id: data
        count: 0
        isActive: false
        name: data
      - id: query
        count: 0
        isActive: false
        name: query
      - id: tool
        count: 0
        isActive: false
        name: tool
    names: []
    assigned: []
FACETS:
  - field: resourceType
    title: Resource Type
    sort: acs
    open: false
    type: text
  - field: kw
    title: Keywords
    sort: acs
    open: true
    type: text
  - field: placenames
    title: Place
    sort: acs
    open: true
    type: text
  - field: pubname
    title: Publisher/Repo
    sort: acs
    open: false
    type: text
  - field: datep
    title: Year Published Range
    sort: acs
    open: true
    type: range
ORDER_BY_DEFAULT: score
ORDER_BY_OPTIONS:
  - field: name
    title: Name
    sort: asc
  - field: pubname
    title: Publisher
    sort: asc
  - field: date
    title: Date
    sort: asc
  - field: score
    title: Relevance
    sort: asc
LIMIT_DEFAULT: 1000
LIMIT_OPTIONS:
  - 10
  - 50
  - 100
  - 1000
  - 5000
RELATEDDATA_COUNT: 10
NOTEBOOKS:
  - name: binder
    badge: https://img.shields.io/badge/-Binder-579ACA.svg?logo=data:image/png;base64,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
    baseurl: https://mybinder.org/v2/gh/earthcube/NotebookTemplates.git/geocodes_template
    binderEncodeParameters: true
    dispatcherPage: urlpath=notebooks/template.ipynb
    contentQuery: dataset={"contenturl":"${contentUrl}","encoding":"${format}","urn":"${urn}"}
    pageTemplate: nb=${notebooktorun}
    formats:
      - text/csv
      - text/tsv
      - text/tab-separated-values
      - application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
  - name: Collab-Service
    badge: https://camo.githubusercontent.com/84f0493939e0c4de4e6dbe113251b4bfb5353e57134ffd9fcab6b8714514d4d1/68747470733a2f2f636f6c61622e72657365617263682e676f6f676c652e636f6d2f6173736574732f636f6c61622d62616467652e737667
    baseurl: https://geocodes.ncsa.illinois.edu/notebook/mknb
    binderEncodeParameters: false
    contentQuery: url=${contentUrl}&ext=${format}&urn=${urn}&encoding=${format}
    pageTemplate: ''
    formats:
      - "*"
```

### important changes
* host is machine host
* GC_CLIENT_DOMAIN
* TRIPLESTORE_URL
* SUMMARYSTORE_URL
* jsonLD_proxy

## issues:
[traefik admin](https//admin.{HOST})
