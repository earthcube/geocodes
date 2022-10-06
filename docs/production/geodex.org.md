log into geodex.org


notes:
update the version on the on facetsearch for it to know you got the correct one.
`cd code/geodex`

`./refresh_containers.sh `

`./restart_all.sh`

to find an issue

`cat restart_all.sh`

grab the command line

change up -d to

log {service2view}

eg

`docker-compose --env-file env.beta -f headless-only.yml -f geocodes-compose.yaml  -f geodex-compose.yml   logs vue-services`

You canfigure out the running endpoints from the /config route.

http://localhost:3000/config
https://geocodes.earthcube.org/ec/api/config


NOTES:
Things borked... match to staging or dev config...
be careful, dev config points to localhost, so do not blindly copy

Inside the geocodes.yaml there is a machine path..
```
vue-services:
image: nsfearthcube/ec_facets_api_nodejs:latest
#build: ./server
restart: unless-stopped
environment:
- NODE_ENV=production
#- S3ADDRESS=s3system:9000
- S3ADDRESS=oss.geocodes.earthcube.org
- S3BUCKET=sites
- S3PREFIX=alpha
- DOMAIN=https://${HOST:?HOST environment varaible is required}/
- S3KEY=${S3KEY}
- S3SECRET=${S3SECRET}
```
