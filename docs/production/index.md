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

* [Prodcution UI DNS/Server changes](production_ui_deployment.md)
* [Creating Configurations for Production](creatingAndLoadingProduction.md)
    * [Production Configuration Fragments](production_configs.md)
* [Managing Services](managing_services.md)
* [Testing/Onboarding a Datasource](../data_loading/onboarding_or_testing_a_datasource.md)
* [Maanging Geocodes UI Containers](managing_geocodes_ui_containers.md)
* [Some Sparql queries](sparql.md)
* [Notebook Proxy Container](geocodes_notebook_proxy_notes.md)

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


