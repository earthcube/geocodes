# minio client
Minio Client will help push and manage items in minio/s3 from the command line.
basically, we can remove old datasets, empty buckets, etc.


## install client
[minio client](https://min.io/docs/minio/linux/reference/minio-mc.html?ref=docs)

```shell
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
--create-dirs \
-o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

mc --help
```

## if midnight commander is installed
* add file .bash_aliases
``` {.shell .copy}
alias mc=' $HOME/minio-binaries/mc'
```

## configure client

 Note the single quotes around the password... some passwords are   not command line friendly
```{. shell .copy }
set +o history
mc config host add dev https://oss.geocodes.earthcube.org  {miniouser} '{miniopassword}'

set -o history
```

## Some commands:

Note these are using a dev alias
Use [mc alias set](https://min.io/docs/minio/linux/reference/minio-mc/mc-alias-set.html#command-mc.alias.set) to set an alias

### What Buckets

`mc ls dev`

```
[2022-07-28 09:52:51 PDT]     0B citesting/
[2023-04-17 14:44:09 PDT]     0B deepoceans/
[2023-01-11 09:03:29 PST]     0B dv-testing/
[0000-12-31 16:07:02 LMT]     0B gleaner/
[2022-10-18 05:30:41 PDT]     0B gleaner-wf/
[2023-01-20 11:35:22 PST]     0B mb-testing/
[2022-09-19 09:35:23 PDT]     0B mbci2/
[2023-04-19 09:45:10 PDT]     0B opencore/
[2023-03-11 16:13:11 PST]     0B public/
```

### Bucket Disk usage

`mc du --depth 2 dev/citesting`

```
107KiB	9 objects	citesting/milled
1.2KiB	1 object	citesting/orgs
68KiB	40 objects	citesting/prov
30B	2 objects	citesting/reports
107KiB	1 object	citesting/results
58KiB	9 objects	citesting/summoned
341KiB	62 objects	citesting
```
