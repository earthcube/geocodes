## Troubleshooting 

### Complaints about bad certificate
Initially, we are using letsencypt dev services. THis message will show until you
rebuild the base containers with the dev line commented out

### cannot connect to (minioadmin,graph,sparqlui)
* is the traefik proxy a SCOPE swarm
  * `docker network ls`
  * portainerui, networks
* is the DNS correct?
  * need a dig example, since editing host and NS looku
* are they running?
  * docker ps
  * portainer stack 

