# notes on managing Services

* minio
* blazegraph


## Minio
### what servers exist in the minio configuration

`mc alias ls`

### minio add configuration for a server
Note the single quotes around the password... some passwords are   not command line friendly
```{ .shell .copy }
set +o history
mc config host add dev https://oss.geocodes.earthcube.org  {miniouser} '{miniopassword}'

set -o history
```

### test
```{ .shell .copy }
mc ls dev
```

### Mino sync between servers
```{ .shell .copy }
mc cp --recursive dev/ecrr/ gc1/ecrr/
```

### copy log files to minio

```shell
cd indexing/logs
mc cp  --recursive . dev/gleaner/logs/{date}
mc share download --recursive dev/gleaner/logs/{date}

```
### links for a bucket:

(IGNORE: only works for top level of bucket... may need a better policy)

```{ .shell .copy }
mc anonymous links --recursive dev/gleaner/summoned/amgeo
```

### statistics for a bucket
```
mc ls dev/gleaner/summoned/{repo} --summarize --recursive

mc ls dev/gleaner/summoned/amgeo --summarize --recursiv


mc stat --recursive  dev/gleaner/summoned/{repo}
```

eg

mc stat --recursive  dev/gleaner/summoned/amgeo

### Remove old records:

```
mc rm dev/gleaner/results --recursive --older-than 365d00h00m00s
mc rm dev/gleaner/summoned --recursive --older-than 365d00h00m00s
mc rm dev/gleaner/milled --recursive --older-than 365d00h00m00s
```

## BLAZEGRAPH
### Uploading the release graphs
There are several ways to upload release graphs.
1. curl
```
curl -X POST -H 'Content-Type:text/x-nquads' --data-binary '@bcodmo_release.nq' https://graph.geocodes-aws.earthcube.org/blazegraph/namespace/deepoceans/sparql
```
2. In the blazegraph UI, the tab `UPDATE` allows you to upload small graphs.  

### Cleaning up the journal
Blazegraph (and fuseki) will grow as data is added, its a journaled file system so it's not 
cleaned up.

The steps  are originally from (Medium.com)[https://medium.com/@nvbach91/how-to-reclaim-disk-space-in-blazegraph-95a47575f8a8]

(MIKE WILL INSERT INSTRUCTIONS HERE)



### deleting:
https://www.w3.org/TR/sparql11-update/#clear
``` { .text .copy }
`CLEAR ALL`
## Clear a graph
`CLEAR GRAPH earthcube:{iri}`
```
