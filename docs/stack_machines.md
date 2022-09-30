| container      | name            | stack             |  | notes                                    
|----------------|-----------------|-------------------|---|------------------------------------------|
| traekfik       | admin           | base              |   | http router                              |
| portainer      | portainer       | base              |   | container management                     |
| s3system       | oss, minioadmin | services          |   | s3 store                                 |
| triplestore    | graph           | services          |   |                                          |
| sparqlgui      | sparqlui        | services          |   | sparql ui                                |
| headless       | {none}          | gleaner_via_shell |   | start with ./run_gleaner.sh   |
| vue-client     | geocodes        | geocodes          |   | facetsearch ui                           |
| vue-services   | geocodes        | geocodes          |   | api ,at geocodes/ec/api                  |
| notebook-proxy | geocodes        | geocodes          |   | notebook proxy, at geocodes/notebook     |
| geodexclient         | geodex          | services |   | for harvesting                       |
| geodexapi     | api             | services |   | for harvesting                       |


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
