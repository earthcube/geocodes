# Production

??? example "Layout of Geocodes Stacks and Containers"
    ~~~mermaid
    flowchart TB
        subgraph Base Machine Stacks
          subgraph base
             traefik[traefik routing]
             portainer[portainer container admin]
          end
          subgraph services
             oss["oss s3"]
             sparqlgui
             triplestore["graph -- triplestore"]
          end
          subgraph geocodes
             facetsearch-->facetsearchservices
          end
          subgraph gleaner
             headless
          end
      end
    ~~~

## Pages:

* [Configuration for loading](creatingProductionConfigs.md)
* [Managing Services](managing_services.md)
* [Some Sparql queries](sparql.md)

## Machines:

* [geodex.org](./geodex.org.md)
* [geocodes.earthcube.org](./geocodes.earthcube.org.md)

## Builds:

* Containers
    * [dockerhub nsfearthcube](https://hub.docker.com/orgs/nsfearthcube/repositories)
* actions
* github


## Troubleshooting


### I refreshed and i get a 404:

1. See if container is running in portainer
1. Look at the portainer container log
1. See if the treafik is mangled.

[`https://admin.geodex.org/dashboard/#/`](https://admin.geodex.org/dashboard/#/)    (admin:password)


