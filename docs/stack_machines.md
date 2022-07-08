| container      | name            | stack    |  | notes                                
|----------------|-----------------|----------|---|--------------------------------------|
| traekfik       | admin           | base     |   | http router                          |
| portainer      | portainer       | base     |   | container management                 |
| s3system       | oss, minioadmin | services |   | s3 store                             |
| triplestore    | graph           | services |   |                                      |
| sparqlgui      | sparqlui        | services |   | sparql ui                            |
| headless       | {none}          | services |   | for harvesting                       |
| vue-client     | geocodes        | geocodes |   | facetsearch ui                       |
| vue-services   | geocodes        | geocodes |   | api ,at geocodes/ec/api              |
| notebook-proxy | geocodes        | geocodes |   | notebook proxy, at geocodes/notebook |
| geodexclient         | geodex          | services |   | for harvesting                       |
| geodexapi     | api             | services |   | for harvesting                       |
