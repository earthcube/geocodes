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
* setup namespace in graph
* setup bucket in minio
* ask project to setup a DNS name for the client:
   * `geocodes.project.org CNAME geocodes-dev.earthcube.org`


### Add data

#### create a config for the project, run and load data to the namespace and graph
  * data
    * add tab to the sources spreadsheet, use that location url
    * OR just use a local csv
  * `glcon config init --cfgName {project}`
  *  edit localConfig.yaml
    * `nano configs/{project}/localConfig.yaml`
  * `glcon config generate --cfgName {project}`
  * `glcon gleaner batch --cfgName {project}`
  * `glcon nabu prefix --cfgName {project}`


| Item    | Name                             | This instance            |
|---------|----------------------------------|--------------------------|
| project | GC_BASE                          | export GC_BASE={project} |
| DNS     | DNS HOST                         | geocodes.{dns}           |
| graph   | graph.XXXX.XXX                   | {project}                |
| summary | graph.XXXX.XXX                   | {project}_summary        |
| bucket  | oss.xxxx.xxx                     | {project}                |
| config  | {on docker/portainer server xxx} | facets_config_{project}  | 


### Configure Client

#### add a config in portainer (facets_config_{project})
    * using namespaces, minio and dns from above
#### setup tenant stack
    * add a stack with project name  using  geocodes-compose_named.yaml
    * Before saving,  env var GC_BASE with project name


