# Running the geocodes chart on kind

Draft notes for bringing `helm/geocodes` up on a throwaway [kind](https://kind.sigs.k8s.io/)
cluster. The chart has only been exercised on kind in pieces (the SeaweedFS
StatefulSet, the bucket job, QLever's sync + index + SPARQL query). Everything
else is untested; see [Open items](#known-gaps) below.

The two files here are deliberately small:

| File | Purpose |
|---|---|
| `kind-config.yaml` | One-node cluster with the ingress ports mapped to the host |
| `values-local.yaml` | Overlay for localhost, no TLS, smaller volumes, no GitHub OAuth |

## Why Traefik

The chart's defaults assume Traefik and depend on it more than most charts do:

- `global.ingress.className: traefik` is the default.
- `global.ingress.traefikMiddlewares: true` makes the chart render
  `traefik.io/v1alpha1` `Middleware` objects (`templates/middlewares.yaml`) that
  strip `/ec/api`, `/notebook` and `/graphspace/<name>`. The apps expect the
  prefix gone: the API serves at `/` and is published at `/ec/api`.

Without those CRDs the Middleware objects fail to apply and the prefixes are
never stripped, so the API and notebook proxy return 404s and QLever's
`/graphspace/<name>` path lands on the root route.

The alternative is to set `traefikMiddlewares=false` and `className=nginx`,
then reproduce the three rewrites with
`nginx.ingress.kubernetes.io/rewrite-target`. That is more moving parts than
just installing Traefik, which is what the instructions below do.

## 1. Create the cluster

```bash
kind create cluster --config helm/local/kind-config.yaml
```

This maps the node's ports 8000/8443 (Traefik's defaults) to 8080/8443 on the
host. `*.localhost` resolves to `127.0.0.1` on macOS, so no `/etc/hosts` edits
are needed. If your resolver does not do that, add:

```
127.0.0.1 geocodes.localhost qlever.localhost qlever-ui.localhost
127.0.0.1 sparqlui.localhost qlever-petrimaps.localhost
127.0.0.1 oss.localhost s3admin.localhost
```

## 2. Install Traefik with its CRDs

The chart's Middleware templates need the `traefik.io` CRDs, which the Traefik
chart installs. Pin `ingressClass` to what the chart expects (its default
`traefik`), and make the entrypoints reachable through the kind port mappings:

```bash
helm repo add traefik https://traefik.github.io/charts
helm repo update

helm install traefik traefik/traefik -n traefik --create-namespace \
  --set ingressClass.enabled=true \
  --set ingressClass.name=traefik \
  --set 'ports.web.nodePort=30080' \
  --set 'ports.websecure.nodePort=30443' \
  --set service.type=NodePort
```

The NodePorts are what `kind-config.yaml` maps: host 8080 → node 30080 and host
8443 → node 30443. kind forwards host ports to ports on the node container, and
only the NodePort range (30000–32767) listens on the node, which is why Traefik
is installed as `NodePort` here rather than a LoadBalancer.

Then wait for it, and confirm the CRDs the chart depends on exist:

```bash
kubectl -n traefik rollout status deploy/traefik
kubectl get crd middlewares.traefik.io
```

## 3. First install: object store only

QLever needs release graphs in S3 before it can start, and nothing creates them
locally. So bring up the object store first, seed it, then add the rest.

```bash
helm install geocodes helm/geocodes -n geocodes --create-namespace \
  -f helm/local/values-local.yaml \
  --set qlever.enabled=false \
  --set sparqlgui.enabled=false \
  --set qlever.ui.enabled=false \
  --set qlever.petrimaps.enabled=false
```

Watch the bucket job and the StatefulSet:

```bash
kubectl -n geocodes get pods -w
kubectl -n geocodes logs job/geocodes-s3-buckets
```

The job creates `gleaner`, `sites`, `forms` and `geocodes`, and applies the
public-read/CORS policy to `geocodes/scheduler/configs/`, `reports/` and
`graphs/`.

Grab the generated credentials (the same values as the Portainer
`MINIO_ROOT_*` variables):

```bash
kubectl -n geocodes get secret geocodes-s3 \
  -o jsonpath='{.data.accessKey}' | base64 -d; echo
kubectl -n geocodes get secret geocodes-s3 \
  -o jsonpath='{.data.secretKey}' | base64 -d; echo
```

## 4. Seed a release graph

The `facetsearch` graphspace indexes
`s3://geocodes/graphs/latest/`, reading files named `<source>_*.nq` for each
entry in `qlever.projects[0].sources` (see
`templates/qlever/qleverfile-secret.yaml`). With the draft values that means
`graphs/latest/geocodes_examples_*.nq`. Without those files the QLever pod
crash-loops.

Two ways to get data in.

**With `aws-cli` in the cluster** (no host tooling needed). Create a pod with
the credentials, then copy from your host:

```bash
ACCESS=$(kubectl -n geocodes get secret geocodes-s3 -o jsonpath='{.data.accessKey}' | base64 -d)
SECRET=$(kubectl -n geocodes get secret geocodes-s3 -o jsonpath='{.data.secretKey}' | base64 -d)

kubectl -n geocodes run aws -it --rm \
  --image=amazon/aws-cli:latest \
  --env="AWS_ACCESS_KEY_ID=$ACCESS" \
  --env="AWS_SECRET_ACCESS_KEY=$SECRET" \
  --env="AWS_DEFAULT_REGION=us-east-1" \
  --command -- sh -c '
    aws --endpoint-url http://geocodes-s3:8333 s3 ls s3://geocodes/ || true
  '
```

**Or port-forward the S3 endpoint** and use `rclone`/`aws` from the host:

```bash
kubectl -n geocodes port-forward svc/geocodes-s3 8333:8333
# then, against http://localhost:8333
rclone sync ./local-graphs/ :s3:geocodes/graphs/latest/ \
  --s3-provider=SeaweedFS --s3-endpoint=http://localhost:8333 \
  --s3-access-key-id="$ACCESS" --s3-secret-access-key="$SECRET"
```

A small, hand-written `.nq` is enough to prove the pipeline works. It only
needs to be valid N-Quads and be named `geocodes_examples_*.nq`; the
Qleverfile's `VOCABULARY_TYPE=on-disk-compressed-geo-split` wants
`geo:asWKT` literals for the map layers, so include at least one geometry if
you want Petrimaps to show anything.

If your files are named differently, either rename them or edit the `sources`
list in `values-local.yaml` — the two have to match.

## 5. Enable the rest

```bash
helm upgrade geocodes helm/geocodes -n geocodes \
  -f helm/local/values-local.yaml
```

QLever rebuilds its index on every pod start, in an `emptyDir`. Watch it:

```bash
kubectl -n geocodes logs -f statefulset/geocodes-qlever-facetsearch -c sync-data
kubectl -n geocodes logs -f statefulset/geocodes-qlever-facetsearch -c qlever
```

The startup probe allows 2 hours (`failureThreshold: 240` × 30s) because
indexing is slow, so a long wait is normal, not a hang.

## 6. Reach the UIs

| URL | Component |
|---|---|
| http://geocodes.localhost:8080/ | facet search client |
| http://geocodes.localhost:8080/ec/api | API (prefix stripped by Middleware) |
| http://geocodes.localhost:8080/notebook | notebook proxy |
| http://qlever.localhost:8080/graphspace/facetsearch | QLever SPARQL |
| http://qlever-ui.localhost:8080/ | QLever UI |
| http://sparqlui.localhost:8080/ | YASGUI |
| http://qlever-petrimaps.localhost:8080/ | Petrimaps |
| http://oss.localhost:8080/ | SeaweedFS S3 API |
| http://s3admin.localhost:8080/ | SeaweedFS admin (`admin` + password from the Secret) |
| http://sched.localhost:8080/ | Dagster UI (only with `dagster.enabled=true`) |

A quick check that the triplestore answers:

```bash
curl -s 'http://qlever.localhost:8080/graphspace/facetsearch?query=SELECT%20*%20WHERE%20%7B%20%3Fs%20%3Fp%20%3Fo%20%7D%20LIMIT%201' \
  -H 'Accept: application/sparql-results+json'
```

## Known gaps

- **Dagster is off by default.** Enable it with `--set dagster.enabled=true`.
  It ports the scheduler's compose stacks (webserver, daemon, Postgres, the gRPC
  code servers) and adds the RBAC `dagster-k8s` needs. It is a draft: it renders
  and lints, but has not run on a cluster, and the code-server image comes from
  the scheduler repo. The Dagster UI lands on `sched.localhost:8080`.
- **`qlever.ui` is amd64-only.** On Apple Silicon, under kind (which runs the
  node as `linux/arm64`), that Deployment does not have a usable image. Leave
  it off (`--set qlever.ui.enabled=false`) or build a multi-arch image.
  `nsfearthcube/*` is on `latest`/`master` and is similarly x86-leaning.
- **Dagster is off by default and is a draft.** `--set dagster.enabled=true`
  brings up the webserver, daemon, Postgres and the code servers, but it needs
  the `nsfearthcube/dagster-gleanerio*` images (built in the scheduler repo) and
  has not been run on a cluster. Point a locally-run Dagster at this cluster
  instead if you only want to test the pod launcher.
- **CORS** on the API and QLever is not set by the chart, so the browser will
  block cross-origin calls from the client to `qlever.localhost`. Same-origin
  paths (`/ec/api`) are fine.
- **`s3admin` password** is generated; use the Secret rather than guessing.
- **The graphspace is `facetsearch`; the facets config also references `ecrr`.**
  `ECRR_TRIPLESTORE_URL` points at a graphspace that does not exist by default,
  which is harmless until something calls it.
