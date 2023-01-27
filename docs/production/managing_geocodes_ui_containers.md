# Manging Geocodes UI containers

### Updating a GEOCODES CLIENT Configuration

You can modify the facets_config config, in order to do this, stop the stack,
delete the config and recreate the config.

1. go to portainer,
1. select geocodes_geocodes, stop
2. select config, facets_config, copy content, select delete
3. create a new config with name 'facets_config', paste in content
4. modify content, save
5. restart stack
6. update the service
    7. services, geocodes_vue-client or geocodes_xxx_vue-client
    8. udate the service
       *** NOTE: TRY A SECOND BROWSER... and/or Clear browser cache ****
    9. If that does not work, check to see in services if the correct container image is being pulled.
9. Then go to containers, geocodes_vue-client or geocodes_xxx_vue-client
    10. remove container. It will rebuild if it is not stopped


---

## DEVELOPERS: Testing a UI Branch in Portainer/Docker

> :memo: An Update May be needed. You can now deploy a tennant configuration, which many mean that geocodes repo changes
> may not be needed

> :memo: you should do local development before deployment testing

To do this we will need to do two branches, one on the facet search, and one on the services stack geocodes.
Or, you can disconnect your development services

### Facetsearch repository changes

* create a branch
    * on that branch edit the github workflows/docker_xxx add your branch

```yaml
on:
  push:
    branches:
    - master
    - feat_summary
```

* make changes and push

### geocodes repository changes

* create a branch
* modify   deployment/geocodes-compose.yaml
```yaml
vue-services:
  image: nsfearthcube/ec_facets_api_nodejs:{{BRANCH NAME}}
  ```

```yaml
vue-client:
  image: nsfearthcube/ec_facets_client:{{BRANCH NAME}}
  ```

### Deployment in in portainer

* create a new stack
* under advanced configuration
  ??? example "stack deploy from a branch"
  ![](images/portainer_branch_deployment.png)
* save
* pull and deploy


----

## Troubleshooting

### seems like  the container is not getting updated
occasionally, a branch is being used for a stack. This will  be true of alpha/beta/tennant
containers.

* open stack
* user Redeploy from Git: select advanced configuration
* change the branch information
  ??? example "stack deploy from a branch"
  ![](images/portainer_branch_deployment.png)

Occasionally, the latest will not be pulled, Seen  when I  change a branch,

* open services,
* select a service,
* go down to Change container image
* set to the appropriate container path.
  ??? example "stack deploy from a branch"
  ![](images/service_change_container.png)
