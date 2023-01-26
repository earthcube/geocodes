## Stack Containers

This is a list of the stack containers.

**NOTE, for production stacks, DNS Names listed need to be cnamed.
REPEAT, so to setup a test machine for production, you need to request DNS.**
The local stacks are under developement.

| container     | name         | stack             | -local path                    | notes                                           
|---------------|--------------|-------------------|------------------------------------|-------------------------------------------------|
| traekfik      | admin.{HOST} | base              | http://localhost:8888/dashboard/#/ | http router                                     |
| portainer     | portainer.{HOST}    | base              | n/a                                | container management                            |
| s3system      | oss.{HOST}          | services          | http://localhost:9000              | s3 store                                        |
| s3system      | minioadmin.{HOST}   | services          | http://localhost:9001              | s3 store                                        |
| triplestore   | graph.{HOST}        | services          | http://localhost:8888/blazegraph/  |                                                 |
| fuseki        | graph2.{HOST}       | fuseki            |                                    | WILL BE ADDED TO Services to replace triplstore |
| sparqlgui     | sparqlui.{HOST}     | services          | http://localhost:8888/sparqlgui    | sparql ui                                       |
| headless      | {none}       | gleaner_via_shell |                                    | start with ./run_gleaner.sh                     |
| vue-client    | geocodes.{HOST}     | geocodes          | http://localhost:8888/             | facetsearch ui                                  |
| vue-services  | geocodes.{HOST}     | geocodes          | http://localhost:8888/ec/api       | api ,at geocodes/ec/api                         |
| notebook-proxy | geocodes.{HOST}     | geocodes          | http://localhost:8888/notebook     | notebook proxy, at geocodes/notebook            |
| geodexclient  | geodex.{HOST}       | geodex            | n/a                                | for harvesting                                  |
| geodexapi     | api.{HOST}          | geodex            | n/a                                | for harvesting                                  |

??? info "Containers and Routes"
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
