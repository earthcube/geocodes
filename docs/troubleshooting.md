## Troubleshooting 

Some topics (sorry disorganized notes)

* Containers
    * can't seem to connect
    * Complaints about bad certificate
    * cannot connect to (minioadmin,graph,sparqlui)
    * Minoadmin/Graph/etc seem to be there, but do not connect
* glcon/gleaner application
* Blazegraph
    *   journal truncation
* updating portainer
* OS issues
    * Ubuntu docker
    * Ubuntu 16. glcon

## can't seem to connect;
are containers running
`docker ps`

can you connect to portainer and traefik

traefik: 
```
https://admin.{HOST}
```

portainer: 
```
https://portainer.{host}
```

In traefik, are  errors on the https://admin.{host}

### Complaints about bad certificate

Initially, we are using letsencypt dev services. THis message will show until you
rebuild the base containers with the dev line commented out

#### But that line is commented out.
  need to delete the acme.json and restart the container.

log onto console via portainer, use /bin/sh
```shell
/ # ls
acme.json      dev            etc            lib            mnt            proc           run            srv            tmp            var
bin            entrypoint.sh  home           media          opt            root           sbin           sys            usr
/ # cat acme.json 
{
  "httpresolver": {
    "Account": {
      "Email": "dwvalentine@ucsd.edu",
      "Registration": {
        "body": {
          "status": "valid",
          "contact": [
            "mailto:dwvalentine@ucsd.edu"
          ]
        },
        "uri": "https://acme-v02.api.letsencrypt.org/acme/acct/1030461777"
        
```

```sheel
rm acme.json
```
 
some docker command also...



### cannot connect to (minioadmin,graph,sparqlui)

* is the traefik proxy a SCOPE swarm
`docker network ls`
  * portainerui, networks
* is the DNS correct?
  * need a dig example, since editing host and NS looku
* are they running?
  * `docker ps`
      * do you see portainer stack 

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

You probably have environment variables set.
```shell
ubuntu@geocodes-dev:~/indexing$ env
[snip]
MINIO_SECRET_KEY=MySecretSecretKeyforMinio
MINIO_ACCESS_KEY=MySecretAccessKey
[snip]
ubuntu@geocodes-dev:~/indexing$ unset MINIO_SECRET_KEY
ubuntu@geocodes-dev:~/indexing$ unset MINIO_ACCESS_KEY
```


## Blazegraph journal truncation:


### for a container
in newer container, the command is available, but the service needs to be stopped.
guess running an container with an exec command in a different container might work.

```
cd /var/lib/blazegraph ;java -jar /usr/bin/blazegraph.jar com.bigdata.journal.CompactJournalUtility blazegraph.jnl blazegraph.jnl.compact


```


### count quads 
```text
SELECT (COUNT(*) as ?Triples) WHERE {graph ?g {?s ?p ?o}}
```

## updating Portainer, or treafik

the latest image needs to be pulled

`docker pull portainer/portainer-ce:latest`

then
`./run_base.sh`

## OS Issues
place where  os issues may be 

### Ubuntu Docker
If you are running on Ubuntu, you need to remove the provided docker.com version. [Official docker package](https://docs.docker.com/engine/install/ubuntu/)
We suggest that for others, confirm that you can run

    ```shell
    docker compose version
    Docker Compose version v2.13.0
    ```

    If you cannot run `docker compose` then update to the docker.com version
    This is the version we are presently running.

    ```    
    Client: Docker Engine - Community
         Version:           20.10.21
         API version:       1.41
    ```

### Ubuntu 18 and glcon
there appears to be issues with Ubuntu 18 and the latest versions of the golang library viper.
If you run on Ubuntu 20.X it works.
Solution is to 'do-realse-upgrade' and wait ;)

```shell
ubuntu@geocodes-dev:~$ uname -a
Linux geocodes-dev 4.15.0-194-generic #205-Ubuntu SMP Fri Sep 16 19:49:27 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
ubuntu@geocodes-dev:~$ cd indexing/
ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner batch --cfgName ci
version:  v3.0.8-ec
{"file":"/Users/valentin/development/dev_earthcube/gleanerio/gleaner/pkg/cli/gleaner.go:71","func":"github.com/gleanerio/gleaner/pkg/cli.initGleanerConfig","level":"fatal","msg":"error reading config file While parsing config: yaml: unmarshal errors:\n  line 1: cannot unmarshal !!str `\u003c?xml v...` into map[string]interface {}","time":"2023-02-14T15:58:00Z"}
ubuntu@geocodes-dev:~/indexing$
 ```


