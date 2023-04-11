
setup netowrk
setup volumes
setup config

`volume create traefik_data`
`volume create logs`

`docker network create -d overlay --attachable traefik_proxy`

`docker config create   traefik_yml ./traefik-aws/traefik.yml`

# setup stack in portainer

1. edit the portainer_aws.env
1. copy over the base-aws-compose.yaml

  1. or use the git version
```
Name: base
Build method: git repository
Repository URL: https://github.com/earthcube/geocodes
Reference: refs/heads/main
Compose path: dbase-aws-compose.yaml
```

Notes:

https://enginaltay.medium.com/how-to-use-traefik-as-ingress-router-on-aws-fc559f87f4d8
