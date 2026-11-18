# GeoCodes deployment: existing (Portainer) vs Helm

This document compares the two ways of deploying GeoCodes:

- **Existing:** Docker Swarm stacks managed by Portainer, defined in [`deployment/`](../deployment) in this repo and in `dagster/implnets/deployment/` in the [scheduler](https://github.com/earthcube/scheduler) repo.
- **Helm:** the chart in [`helm/geocodes/`](geocodes), and the Kubernetes container launcher on the scheduler's `helm` branch.

The Helm chart is new and has not run in production. Unless a section says otherwise, "tested" means a throwaway `kind` cluster.

## At a glance

| Concern | Existing (Portainer / Docker Swarm) | Helm |
|---|---|---|
| Orchestration | Single-node Docker Swarm. Portainer deploys separate stacks (base, services, geocodes, qlever, scheduler) | One Helm release. Each component can be switched on or off in `values.yaml` |
| Routing and TLS | Traefik in the base stack. Routes come from `traefik.*` labels on each service; Let's Encrypt certificates come from Traefik's ACME resolver (configured for the staging CA) | Uses the cluster's ingress controller and one `Ingress` per component. Traefik `Middleware` resources strip path prefixes. TLS comes from cert-manager annotations |
| Object store | MinIO (`quay.io/minio/minio`) | SeaweedFS (`weed server -s3`), because MinIO no longer publishes pullable images |
| Triplestore | Blazegraph, with QLever added in the recent "Qlever (#55)" commit | QLever only, one server per graphspace |
| Hostnames | Each one written out in full in env files (`GLEANER_*_DOMAIN`), because Portainer can't substitute variables | Built as `<subdomain>.<global.host>`, with an optional `host` override per component |
| Config files | Swarm configs created by hand or with `run_add_configs.sh` (`facets_config`, `qlever-config-*`) | A ConfigMap (facets config) and a Secret (Qleverfile), both rendered from values |
| Secrets | Plain values in env files, with example credentials committed | Kubernetes Secrets, generated on first install and kept across upgrades, or supplied through `existingSecret` |
| Buckets and public read | Set up by hand in the MinIO console | A post-install job creates the buckets and applies public-read policies and CORS |
| Harvesting (Gleaner/Nabu) | Dagster starts Swarm one-off jobs through the Portainer API | Dagster starts Kubernetes pods through `dagster-k8s` (`GLEANERIO_LAUNCHER=k8s`) |
| Scheduler (Dagster) | Portainer stack from the scheduler repo | `dagster` in the chart (off by default), a first draft (see [Open items](#open-items)) |

## Components

| Existing service | Where it's defined | Helm component | Status |
|---|---|---|---|
| `traefik` | `base-machine-compose.yaml` | None; uses the cluster's ingress controller | Replaced |
| `portainer` | `base-machine-compose.yaml` | None; Helm manages releases | Replaced |
| `s3system` (MinIO) | `services-compose.yaml` | `s3` (SeaweedFS StatefulSet, bucket job, `weed admin` UI) | Tested |
| `graph` (Blazegraph) | `services-compose.yaml` | None; QLever replaces it | Dropped |
| `sparqlgui` (YASGUI) | `services-compose.yaml` | `sparqlgui`, now pointed at QLever | Not tested |
| `vue-client` | `geocodes-compose-named.yaml` / `-production.yaml` | `geocodes.client` | Not tested |
| `vue-services` | same | `geocodes.api` | Not tested |
| `notebook-proxy` | same | `geocodes.notebook` | Not tested |
| `qlever-sync-data` (rclone) | `qlever-services.yaml` | An initContainer in each `qlever` server pod | Tested |
| `qlever-server-*` | `qlever-services.yaml`, `qlever-server-project.yaml` | `qlever.projects[]`, one StatefulSet per graphspace | Tested (index and SPARQL query) |
| `qlever-ui` | `qlever-services.yaml` | `qlever.ui` | Not tested (image is amd64-only) |
| `qlever-petrimaps` | `qlever-services.yaml` | `qlever.petrimaps` | Not tested |
| `headless` (Chrome) | `gleaner-compose.yaml`, scheduler `compose_project_ingest.yaml` | `headless` (off by default) | Not tested |
| `graph2` (Fuseki) | `fuseki-compose.yaml` | None | Dropped |
| `geodexclient`, `geodexapi`, `mercantile` | `geodex-compose.yml` | None | Dropped (legacy) |
| `dagster-dagit`, `dagster-daemon`, `dagster-postgres` | scheduler `compose_project.yaml` | `dagster`, `dagster-postgres` | Drafted, not run |
| `dagster-code-*` (ingest, tasks, ecrr) | scheduler `compose_project_ingest.yaml`, overrides | `dagster.codeServers[]` | Drafted, not run |
| Gleaner/Nabu runs | Swarm one-off jobs created through the Portainer API | Pods created by `dagster-k8s`, with a log-copy sidecar | Tested with mocks and Docker; not on a cluster |

## Hostnames

| Existing variable | Existing default | Helm value | Helm default |
|---|---|---|---|
| `HOST` | `geocodes-dev.earthcube.org` etc. | `global.host` | `geocodes.example.org` |
| `GC_CLIENT_DOMAIN` | `geocodes.{HOST}` | `geocodes.subdomain` / `geocodes.host` | `geocodes.{host}` (client `/`, API `/ec/api`, notebook `/notebook`) |
| `GLEANER_OSS_DOMAIN` | `oss.{HOST}` | `s3.api.subdomain` | `oss.{host}` |
| `GLEANER_OSS_CONSOLE_DOMAIN` | `minioadmin.{HOST}` | `s3.admin.subdomain` | `s3admin.{host}` |
| `GLEANER_SPARQLGUI_DOMAIN` | `sparqlui.{HOST}` | `sparqlgui.subdomain` | `sparqlui.{host}` |
| `qlever.{HOST}` (in compose labels) | `/graphspace/{PROJECT}` | `qlever.subdomain` | `qlever.{host}/graphspace/<name>` |
| `qlever-ui.{HOST}`, `qlever-petrimaps.{HOST}` | in compose labels | `qlever.ui.subdomain`, `qlever.petrimaps.subdomain` | same names |
| `GLEANER_GRAPH_DOMAIN`, `GLEANER_GRAPH2_DOMAIN` | `graph.{HOST}`, `graph2.{HOST}` | None | Dropped with Blazegraph and Fuseki |
| `GLEANER_ADMIN_DOMAIN`, `GLEANER_PORTAINER_DOMAIN` | `admin.{HOST}`, `portainer.{HOST}` | None | Dropped with Traefik and Portainer |
| `sched.{HOST}` (scheduler) | `SCHED_HOSTNAME` | None yet | Open |

## Configuration mapping

### GeoCodes app and object store

| Existing (env file or Swarm config) | Helm value |
|---|---|
| `MINIO_ROOT_ACCESS_KEY`, `MINIO_ROOT_SECRET_KEY` | `s3.auth.accessKey`, `s3.auth.secretKey`, or `s3.auth.existingSecret` (keys `accessKey`, `secretKey`) |
| `FACETS_CLIENT_TAG`, `FACETS_SERVICES_TAG`, `FACETS_NOTEBOOK_TAG` | `geocodes.client.image.tag`, `geocodes.api.image.tag`, `geocodes.notebook.image.tag` |
| `URIVERSION` | `geocodes.uriVersion` |
| Swarm config `facets_config` (`FACETS_CONFIG_CONFIG`) | [`files/facets-config.yaml`](geocodes/files/facets-config.yaml), rendered with the configured hosts, or `geocodes.client.facetsConfig` |
| `VITE_APP_MAPBOX_API_KEY`, `VITE_APP_TITLE`, `VITE_APP_FACETS_CONFIG_FILE` | `geocodes.client.mapboxApiKey`, `.title`, `.facetsConfigFile` |
| `S3ADDRESS`, `S3PORT`, `S3SSL`, `S3KEY`, `S3SECRET` | `geocodes.api.s3.address`, `.port`, `.ssl`, `.existingSecret` (empty = in-cluster S3) |
| `BUCKET`, `BUCKETPATH`, `TOOLPATH`, `TOOLREPO` | `geocodes.api.bucket`, `.bucketPath`, `.toolPath`, `.toolRepo` |
| `GC_NB_AUTH_MODE`, `GC_GITHUB_CLIENTID`, `GC_GITHUB_SECRET`, `GC_GITHUB_USER`, `GC_GITHUB_TOKEN` | `geocodes.notebook.authMode`, `geocodes.notebook.github.*` or `.github.existingSecret` |
| `SPARQL_DEFAULT_SPARQL_ENDPOINT_PATH` | `sparqlgui.defaultEndpoint` (empty = the first QLever graphspace) |
| Buckets created by hand | `s3.buckets.names` |
| Public read set by hand | `s3.buckets.publicRead` and `s3.buckets.corsAllowedOrigins` |
| `TRAEFIK_AUTH`, `FUSEKI_ADMIN_PASSWORD`, `PORTAINER_EDITION` | None (component dropped) |

### QLever

| Existing (`qlever_env.env`, Swarm config) | Helm value |
|---|---|
| `PROJECT` | `qlever.projects[].name` |
| `S3_ENDPOINT`, `S3_PROVIDER`, `S3_REGION`, `S3_ACCESS_KEY_ID`, `S3_SECRET_ACCESS_KEY` | `qlever.s3.endpoint`, `.provider`, `.region`, `.existingSecret` (empty = in-cluster S3) |
| `S3_BUCKET`, `S3_PATH` | `qlever.projects[].s3Bucket`, `.s3Path` |
| `QLEVER_CONTAINER_TAG` | `qlever.image.tag` |
| Swarm config `qlever-config-${QLEVER_CONFIG}` (the Qleverfile) | Generated from `qlever.projects[]` (`sources`, `memoryForQueries`, `cacheMaxSize`, `timeout`), or `qlever.projects[].qleverfile` |
| `ACCESS_TOKEN` hardcoded in the Qleverfile | `qlever.projects[].accessToken` (empty = generated) |
| `QLEVERUI_SECRET_KEY`, `QLEVERUI_CSRF_TRUSTED_ORIGINS`, `QLEVERUI_CORS_ORIGINS` | `qlever.ui.secretKey`, `.csrfTrustedOrigins`, `.corsOrigins` |
| `CURRENT_UID`, `CURRENT_GID` | `qlever.podSecurityContext` |

### Scheduler (Gleaner/Nabu launcher)

These settings are on the scheduler's `helm` branch. `GLEANERIO_LAUNCHER` defaults to `docker`, so existing deployments keep working unchanged.

| Existing (docker launcher) | Kubernetes launcher (`GLEANERIO_LAUNCHER=k8s`) |
|---|---|
| `GLEANERIO_DOCKER_URL`, `GLEANERIO_PORTAINER_APIKEY` | Not needed. Uses in-cluster config and a ServiceAccount (`GLEANERIO_K8S_SERVICE_ACCOUNT`) |
| `GLEANERIO_DOCKER_HEADLESS_NETWORK` | Not needed. `GLEANERIO_HEADLESS_ENDPOINT` points at the `headless` Service |
| MinIO keys passed as plain env values | Plain values, or `GLEANERIO_K8S_S3_SECRET` (keys `accessKey`, `secretKey`, matching the chart's S3 Secret) |
| Swarm service name `sch_{PROJECT}_{source}_{mode}` | Pod labelled `gleanerio/project`, `gleanerio/source`, `gleanerio/mode` |
| `GLEANERIO_DOCKER_CONTAINER_WAIT_TIMEOUT` (how often logs are uploaded) | Same setting, now the sidecar's copy interval. `GLEANERIO_K8S_POD_TIMEOUT` is the overall limit |
| `logs/` folder uploaded as a `.tar` with `get_archive` | `logs/` copied as individual files by an `rclone` sidecar (`GLEANERIO_K8S_LOG_SIDECAR_IMAGE`) |
| Container output uploaded to `scheduler/logs/<name>_<date>.log` | Unchanged |

## Storage, networks and Swarm resources

| Existing | Helm |
|---|---|
| Volume `minio` | PVC `data` on the `s3` StatefulSet (`s3.persistence`) |
| Volumes `graph`, `graph_2`, `fuseki_*` | None |
| Volume `release_data` (shared by sync and QLever) | One PVC per graphspace (`qlever.projects[].releaseStorage`) |
| QLever index (container filesystem, rebuilt on start) | emptyDir, still rebuilt on start (`qlever.projects[].indexStorage.sizeLimit`) |
| Volume `qleverflow_data` | PVC for `qlever.ui` |
| Volumes `traefik_data`, `portainer_data` | None |
| Networks `traefik_proxy`, `qlever_network`, `headless_gleanerio` | Cluster networking plus one ClusterIP Service per component |
| Swarm configs `facets_config`, `qlever-config-*`, `traefik_yml` | ConfigMap, Secret, none |

## Deliberate behaviour changes

- **S3 inside the cluster:** the API and QLever's download step reach S3 at `http://<release>-s3:8333`. Compose went out through the public `oss.` hostname over HTTPS. Set `geocodes.api.s3.address` and `qlever.s3.endpoint` to keep the old behaviour.
- **`NODE_ENV`:** the API now uses `production`. Compose had the typo `produdction`, so production mode was probably never actually on.
- **Facets config:** URLs follow the configured hosts instead of being hardcoded to `geocodes-aws-dev`. The `hhttps` typo in `JSONLD_PROXY` is fixed, and `S3_REPORTS_URL` uses the `geocodes` bucket instead of `decoder`.
- **QLever startup:** the server starts through a login shell instead of `/qlever/docker-entrypoint.sh`, because that script's `sudo`-based user ID remapping doesn't fit a Kubernetes security context. The Qleverfile uses relative `../release/` paths, as QLever requires. The QLever UI connects to the server's real port, 7019; compose used 7007.
- **Public read:** only the prefixes listed in `s3.buckets.publicRead` can be read without credentials. The default is `geocodes/scheduler/configs/`, `reports/` and `graphs/`.
- **Admin UI:** the MinIO console is replaced by SeaweedFS's `weed admin` UI, protected by a generated password.

## Open items

1. **Dagster deployment:** the `dagster` component in the chart now drafts the web UI, daemon, Postgres, the code servers, `dagster.yaml`, `workspace.yaml` and RBAC, but none of it has run on a cluster. Still open: the ECrr code server, the Slack env vars, and the Gleaner/Nabu configs that write a release graph to S3. Without that data QLever has nothing to index.
2. **Scheduler still needs Blazegraph:** `release_summarize` (temporary namespace), the tenant upload and namespace jobs, and the `SPARQL_ENDPOINT` given to Gleaner/Nabu. These need porting to QLever.
3. **ECRR workflow:** `workflows/ecrr/ecrr/ops` still launches containers only through Docker/Portainer.
4. **Smoke test on an amd64 cluster:** client, API, notebook proxy, QLever UI, petrimaps, YASGUI, headless Chrome.
5. **CORS for QLever and the API:** compose added CORS headers with Traefik labels. The chart doesn't reproduce them yet.
6. **Image tags:** pin the components still on `latest` or `master`.
7. **Facets config:** set a Mapbox key, and define the `ecrr` graphspace or remove `ECRR_TRIPLESTORE_URL`.
8. **Data migration:** `rclone sync` from the existing MinIO; QLever then loads from the existing release files.
9. **Docs and CI:** replace `mc` commands in `docs/production/managing_services.md`; add `helm lint` to CI. The scheduler image workflow doesn't build `helm` branches, and it sets `latest=true`, so a branch build may overwrite the `latest` tag the Portainer stacks deploy.

## Problems in the existing configuration

These affect the existing deployment. The chart avoids or fixes them.

- `GITHUB_USER==${GC_GITHUB_USER}` has a double `=` in the notebook-proxy env (production and named compose files).
- `NODE_ENV: produdction` is misspelled in vue-services.
- vue-client mounts the facets config at different paths in the production file (`/usr/src/app/dist/...`) and the named file (`/app/...`).
- Credentials are committed in plain text: the Traefik basic-auth hash in the compose files, and example MinIO and Fuseki passwords in the env files.
- `traefik.yml` points at the Let's Encrypt staging server.
- In `qlever-services.yaml`, the strip-prefix middleware is attached to a `qlever-project-*` router instead of `qlever-base-*`, so it's probably never applied.
- The QLever UI's `QLEVER_HOST` uses port 7007, but the server listens on 7019.
- The production compose file hardcodes `geocodes.earthcube.org`.
- QLever UI defaults: `QLEVERUI_SECRET_KEY` is `!!super_secret!!`, and CORS/CSRF origins are hardcoded to `*.geocodes-aws-dev.earthcube.org`.
