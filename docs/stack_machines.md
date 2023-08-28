# Stack Containers


## "Containers and Routes"

~~~mermaid
flowchart TB
services-- deployed by -->portainer
geocodes-- deployed by  --> portainer
gleaner-- deployed by  --> portainer
facetsearch-- routes --> traefik
facetsearchservices-- routes-->traefik
oss-- routes-->traefik
triplestore-- routes --> traefik
sparqlgui-- routes --> traefik
subgraph gleaner
headless
end
subgraph geocodes
facetsearch-->facetsearchservices
end
subgraph services
oss["oss s3"]
sparqlgui
triplestore["graph -- triplestore"]
end 
        subgraph base
           traefik<-- routes -->portainer
        end 
~~~


## This is a list of the stack containers.

**NOTE, for production stacks, DNS Names listed need to be cnamed.
REPEAT, so to setup a test machine for production, you need to request DNS.**
The local stacks do no use the traefik routing, and the followign ports need to be available: 3000, 3031,8080, 8888, 9000, 9001, 9999

| container     | name         | stack             | -local path                       | notes                                           
|---------------|--------------|-------------------|-----------------------------------|-------------------------------------------------|
| traekfik      | admin.{HOST} | base              | n/a                               | http router                                     |
| portainer     | portainer.{HOST}    | base              | n/a                               | container management                            |
| s3system      | oss.{HOST}          | services          | http://localhost:9000             | s3 store                                        |
| s3system      | minioadmin.{HOST}   | services          | http://localhost:9001             | s3 store                                        |
| triplestore   | graph.{HOST}        | services          | http://localhost:9999/blazegraph/ |                                                 |
| sparqlgui     | sparqlui.{HOST}     | services          | http://localhost:8888/sparqlgui   | sparql ui                                       |
| headless      | {none}       | gleaner_via_shell | headless:9000 (internal route)    | start with ./run_gleaner.sh                     |
| vue-client    | geocodes.{HOST}     | geocodes          | http://localhost:8080/            | facetsearch ui                                  |
| vue-services  | geocodes.{HOST}     | geocodes          | http://localhost:3000/ec/api      | api ,at geocodes/ec/api                         |
| notebook-proxy | geocodes.{HOST}     | geocodes          | http://localhost:3031/notebook    | notebook proxy, at geocodes/notebook            |

## Docker
When you run local, these should be created

Networks: traefik_proxy
Volumes:
* graph
* s3
* logs
configs:
* configs will be locally mounted, See the docker files.

