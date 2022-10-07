# minio client
Minio Client will help push and manage items in minio/s3 from the command line.
basically, we can remove old datasets, empty buckets, etc.


## install client
[minio client](https://min.io/docs/minio/linux/reference/minio-mc.html?ref=docs)

`curl https://dl.min.io/client/mc/release/linux-amd64/mc \
--create-dirs \
-o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

mc --help`

## if midnight commander is installed
* add file .bash_aliases

 ` alias mc=' $HOME/minio-binaries/mc'`

## configure client

 Note the single quotes around the password... some passwords are   not command line friendly
```shell
set +o history
mc config host add dev https://oss.geocodes.earthcube.org  {miniouser} '{miniopassword}'

set -o history
```


