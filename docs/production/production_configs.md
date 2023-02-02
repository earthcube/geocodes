
# Production configuration settings.
This is just a list of the customized sections of the 'production' configurations
You should be able to 'glean' information needed about what servers and sources are being utilized.


!!! note 
    You will need to customize these for each server.

| service | config | servers  | notes                      |
|--------------| ----|----------|----------------------------| 
| production  | geocodes | geocodes-1 | production from  sources   |
| all | geocodes_all | geocodes-dev | sources from sources sheet |
| gctest | gctest | geocodes.ncsa | example sources from file |
| wifire | wifire | gecodes-dev | wifire from sources sheet |

# Production
Production is a subset of the sources that have been vetted.

environment

localConfig.yaml

facets_search.yaml


# All
This would be a list of all sources and sitemaps.
environment

localConfig.yaml

facets_search.yaml

# gctest

environment

localConfig.yaml

facets_search.yaml

# wifire
environment

localConfig.yaml

facets_search.yaml

