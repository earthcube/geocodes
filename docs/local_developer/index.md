# Local or Developer Stacks

TODO GRAPH OF STACK... or say see index ;)


Container Stacks:
* services
* geocodes

# starting.


## Troubleshooting
Why is dev different from production

dev is built from source and pushed to server automatically by the XXX github action.
geocodes (and alpha and beta) need to be pulled from dockerhub (refreshed), manually.

To see what was last pushed, 
* first go to github and look for the [dockerize view client action](https://github.com/earthcube/facetsearch/actions/workflows/docker_facet_vue_client.yml)
* look for 'master' and see when it was last pushed.
* then go to [dockerhub ec_facets_client)[https://hub.docker.com/repository/docker/nsfearthcube/ec_facets_client], and see what was latest is.
* then if the container needs updating, update it. 
* It's best if you pull to alpha/beta to be sure it is working. But for minor changes, you should be able to pull

I refeched and i get a 404:

http://localhost:8080/admin/dashboard/#/
(admin:password)
