# notes on managing minio


## test
mc ls dev

## copy log files to minio

```shell
cd indexing/logs
mc cp  --recursive . dev/gleaner/logs/{date}
mc share download --recursive dev/gleaner/logs/{date}

```
## links for a bucket:

(IGNORE: only works for top level of bucket... may need a better policy)

mc anonymous links --recursive dev/gleaner/summoned/amgeo

## statistics for a bucket
mc ls dev/gleaner/summoned/{repo} --summarize --recursive

mc ls dev/gleaner/summoned/amgeo --summarize --recursiv


mc stat --recursive  dev/gleaner/summoned/{repo}

eg

mc stat --recursive  dev/gleaner/summoned/amgeo

## Remove old records:

```
mc rm dev/gleaner/results --recursive --older-than 365d00h00m00s
mc rm dev/gleaner/summoned --recursive --older-than 365d00h00m00s
mc rm dev/gleaner/milled --recursive --older-than 365d00h00m00s
```
