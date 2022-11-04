## Troubleshooting 

## can't seem to connect;
are containers running
docker ps

can you connect to portainer and traefik

traefik: https://admin.{HOST}

portainer: https://portainer.{host}

In traefik, are there errors.

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

### Minoadmin/Graph/etc seem to be there, but do not connect
If minioadmin complains that it cannot connect with a 10.0.0.x message, then there 
may be two

* open portainer
* select containers
* sort by name
* look and see if two of the s3 stack are running.
* if yes, delete both, and one should restart.

have also seen something similar for graph.

# glcon
## setup failure 
`./glcon gleaner setup --cfgName {name}`
```json
{"file":"/github/workspace/pkg/gleaner.go:63","func":"github.com/gleanerio/gleaner/pkg.Setup","level":"error","msg":"Connection issue, make sure the minio server is running and accessible.The Access Key Id you provided does not exist in our records.","time":"2022-07-22T19:08:01Z"}
```
You probably have enviroment variables set.
```shell
ubuntu@geocodes-dev:~/indexing$ env
[snip]
MINIO_SECRET_KEY=MySecretSecretKeyforMinio
MINIO_ACCESS_KEY=MySecretAccessKey
[snip]
ubuntu@geocodes-dev:~/indexing$ unset MINIO_SECRET_KEY
ubuntu@geocodes-dev:~/indexing$ unset MINIO_ACCESS_KEY
```


# Blazegraph jounral truncation:


## for a container
in nawer container, the command is available, but the service needs to be stopped.
guess running an container with an exec command in a different container might work.

```
cd /var/lib/blazegraph ;java -jar /usr/bin/blazegraph.jar com.bigdata.journal.CompactJournalUtility blazegraph.jnl blazegraph.jnl.compact


```


## count quads 
SELECT (COUNT(*) as ?Triples) WHERE {graph ?g {?s ?p ?o}}
