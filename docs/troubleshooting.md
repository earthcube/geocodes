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

