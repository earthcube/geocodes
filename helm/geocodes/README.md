# geocodes Helm chart

This chart deploys the GeoCodes stack to Kubernetes. It replaces the Portainer/Docker Swarm stacks in `deployment/`. For a comparison of the existing stacks and this chart, see [../portainer-stack-summary.md](../portainer-stack-summary.md).

| Component | Replaces | Default |
|---|---|---|
| `s3` (SeaweedFS) | `s3system` / MinIO (services stack) | enabled |
| `qlever` (one server per graphspace) | `blazegraph` / `qlever-services.yaml` | enabled, graphspace `facetsearch` |
| `qlever.ui`, `qlever.petrimaps` | `qlever-ui-base`, `qlever-petrimaps-base` | enabled |
| `sparqlgui` (YASGUI) | `sparqlgui` | enabled, points at QLever |
| `geocodes.client` / `api` / `notebook` | `vue-client` / `vue-services` / `notebook-proxy` | enabled |
| `headless` | gleaner headless Chrome | disabled |

Blazegraph, Fuseki, Geodex, Traefik and Portainer are not included. The chart expects the cluster to already provide an ingress controller and, optionally, cert-manager.

## Install

```bash
helm install geocodes ./helm/geocodes -n geocodes --create-namespace \
  --set global.host=geocodes-dev.earthcube.org \
  --set-string 'global.ingress.annotations.cert-manager\.io/cluster-issuer=letsencrypt-prod' \
  --set geocodes.client.mapboxApiKey=pk.xxx \
  --set geocodes.notebook.github.clientId=... \
  --set geocodes.notebook.github.secret=...
```

Hostnames default to `<subdomain>.<global.host>`, the same `{HOST}` pattern the Portainer env files use:

| Default host | Serves |
|---|---|
| `geocodes.{HOST}` | client (`/`), API (`/ec/api`), notebook proxy (`/notebook`) |
| `qlever.{HOST}/graphspace/<project>` | QLever SPARQL endpoints |
| `qlever-ui.{HOST}` | QLever UI |
| `qlever-petrimaps.{HOST}` | Petrimaps |
| `sparqlui.{HOST}` | YASGUI |
| `oss.{HOST}` | S3 API (SeaweedFS) |
| `s3admin.{HOST}` | SeaweedFS admin UI |

To override a single host, set that component's `host` value.

## Notes

- **Ingress:** The default ingress class is `traefik`. With `global.ingress.traefikMiddlewares=true` (the default), the chart creates Traefik `Middleware` resources that strip `/ec/api`, `/notebook` and `/graphspace/<project>`. If you use another controller, turn that setting off and add rewrite annotations under each component's `ingress.annotations`.
- **QLever startup:** On every pod start, an rclone initContainer syncs `s3://<s3Bucket>/<s3Path>` into a PVC mounted at `/release`. QLever then rebuilds its index in an emptyDir and starts serving. This matches what the compose stack did. Until the bucket has `.nq` release files, QLever pods will crash-loop.
- **Adding a graphspace:** Add an entry to `qlever.projects`. The facets config already references a second graphspace, `ecrr`, for `ECRR_TRIPLESTORE_URL`.
- **Facets config:** The client's facets config comes from [files/facets-config.yaml](files/facets-config.yaml), which is rendered with `tpl` so its URLs follow the configured hosts. To replace it entirely, set `geocodes.client.facetsConfig`.
- **Secrets:** The S3 credentials, the S3 admin UI password, QLever access tokens and the QLever UI secret key are generated on first install and kept across upgrades. Each one can also be supplied through values or `existingSecret`.
- **Object store:** S3 is provided by SeaweedFS (`weed server -s3`), because MinIO no longer publishes pullable images. A post-install job creates the buckets in `s3.buckets.names`. It also makes the prefixes in `s3.buckets.publicRead` readable without credentials, with CORS, because the browser loads the tenant config and reports from `oss.{HOST}` directly. Anything not listed still requires credentials.
- **Moving data from MinIO:** Copy each bucket from the old MinIO with `rclone sync` (provider `Minio` for the source, `SeaweedFS` for the destination). Commands in `docs/production/managing_services.md` that use `mc` need an `rclone` or `aws s3` equivalent.
- **S3 access:** By default, the API and QLever reach the in-cluster SeaweedFS directly. To use an external S3 instead, set `s3.enabled=false` together with `geocodes.api.s3.*` and `qlever.s3.*`.
