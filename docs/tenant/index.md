# Setting up tennant
A 'tenant' will allow us to host a project with a separate UI, using common services

* a namepace for the graph and oss in the geocodes.services
* a client at thier DNS, eg. geoocdes.project.org

## Thoughts on initial steps:
### Setup

* Choose a 'project' identifier, This will be an ENV variable ${GC_BASE} set in local environment, or portainer
* setup namespace in graph
* setup bucket in minio
* ask project to setup a DNS name for the client:
   * `geocodes.project.org CNAME geocodes-dev.earthcube.org`


### Configure Client

* add a config in portainer (facets_config_{project})
    * using namespaces, minio and dns from above
* setup tennant stack
    * add a stack with project name  using  geocodes-compose_named.yaml
    * Before saving,  env var GC_BASE with project name


### Add data

* create a config for the project, run and load data to the namespace and graph
  * data
      * add tab to the sources spreadsheet, use that location url
      * OR just use a local csv  
  * glcon config init --cfgName {project}
  *  edit localConfig.yaml
      * nano configs/{project}/localConfig.yaml
  * glcon config generate --cfgName {project}
  * glcon gleaner batch --cfgName {project}
  * glcon nabu prefix --cfgName {project}


| Item    | Name                             | This instance            |
|---------|----------------------------------|--------------------------|
| project | GC_BASE                          | export GC_BASE={project} |
| DNS     | DNS HOST                         | geocodes.{dns}           |
| graph   | graph.XXXX.XXX                   | {project}                |
| summary | graph.XXXX.XXX                   | {project}_summary        |
| bucket  | oss.xxxx.xxx                     | {project}                |
| config  | {on docker/portainer server xxx} | facets_config_{project}  | 
