# Setting up tennant
A 'tennant' will allow us to host a project with a separate UI, using cmmonn services
* a namepace for the graph and oss in the geocodes.services
* a client at thier DNS, eg. geoocdes.project.org

## Thoughts on initial steps:
### Setup
* setup namespace in graph
* setup bucket in minio
* ask project to setup a DNS name for the client:
   * `geocodes.project.org CNAME geocodes-dev.earthcube.org`
### Configure Client
* install geocodes-compose.yaml stack with tennant name as host, namespace and graph
* add a config in portainer (facets_config_{project})
### Add data
* create a config for the project, run and load data to the namespace and graph
  * add tab to spreadsheet, use that location url
  * glcon config init --cfgName {project{
  * nano configs/{project}/localConfig.yaml
  * glcon config generate --cfgName {project}
  * glcon gleaner batch --cfgName {project}
  * glcon nabu prefix --cfgName {projet}


| Item | Name            | This instance |
| ----|-----------------|---------------|
| DNS | DNS HOST        |  geocodes.{dns} |
| graph | graph.XXXX.XXX  | {project}     |
| bucket | oss.xxxx.xxx    | { project} |
| config | {on server xxx} | {project}  location | 
