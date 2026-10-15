{{/* Chart name */}}
{{- define "geocodes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Fully qualified app name */}}
{{- define "geocodes.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Resource name for a component: (dict "root" $ "component" "s3") */}}
{{- define "geocodes.componentName" -}}
{{- printf "%s-%s" (include "geocodes.fullname" .root) .component | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "geocodes.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .root.Chart.Name .root.Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
{{ include "geocodes.selectorLabels" . }}
{{- end }}

{{- define "geocodes.selectorLabels" -}}
app.kubernetes.io/name: {{ include "geocodes.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/* image string from an image block */}}
{{- define "geocodes.image" -}}
{{- printf "%s:%s" .repository (toString .tag) }}
{{- end }}

{{/*
Hostname for a component: (dict "root" $ "values" .Values.s3.api)
Uses values.host if set, otherwise <values.subdomain>.<global.host>.
*/}}
{{- define "geocodes.host" -}}
{{- if .values.host }}
{{- .values.host }}
{{- else }}
{{- printf "%s.%s" .values.subdomain .root.Values.global.host }}
{{- end }}
{{- end }}

{{- define "geocodes.host.geocodes" -}}
{{- include "geocodes.host" (dict "root" . "values" .Values.geocodes) }}
{{- end }}

{{- define "geocodes.host.qlever" -}}
{{- include "geocodes.host" (dict "root" . "values" .Values.qlever) }}
{{- end }}

{{- define "geocodes.host.oss" -}}
{{- include "geocodes.host" (dict "root" . "values" .Values.s3.api) }}
{{- end }}

{{- define "geocodes.host.sparqlgui" -}}
{{- include "geocodes.host" (dict "root" . "values" .Values.sparqlgui) }}
{{- end }}

{{/* Name of the first QLever graphspace */}}
{{- define "geocodes.qlever.defaultProject" -}}
{{- (first .Values.qlever.projects).name }}
{{- end }}

{{/* Public SPARQL endpoint of the first QLever graphspace */}}
{{- define "geocodes.qlever.defaultEndpoint" -}}
{{- printf "https://%s/graphspace/%s" (include "geocodes.host.qlever" .) (include "geocodes.qlever.defaultProject" .) }}
{{- end }}

{{/*
Secret value that is generated once and then preserved across upgrades.
(dict "root" $ "secret" "<secret name>" "key" "<key>" "value" <explicit value> "length" 32)
*/}}
{{- define "geocodes.secretValue" -}}
{{- if .value }}
{{- .value }}
{{- else }}
{{- $existing := lookup "v1" "Secret" .root.Release.Namespace .secret }}
{{- if and $existing (hasKey $existing.data .key) }}
{{- index $existing.data .key | b64dec }}
{{- else }}
{{- randAlphaNum (default 32 .length) }}
{{- end }}
{{- end }}
{{- end }}

{{/* In-cluster S3 (SeaweedFS) credential secret name */}}
{{- define "geocodes.s3.secretName" -}}
{{- if .Values.s3.auth.existingSecret }}
{{- .Values.s3.auth.existingSecret }}
{{- else }}
{{- include "geocodes.componentName" (dict "root" . "component" "s3") }}
{{- end }}
{{- end }}

{{/* In-cluster S3 service host */}}
{{- define "geocodes.s3.serviceHost" -}}
{{- include "geocodes.componentName" (dict "root" . "component" "s3") }}
{{- end }}

{{/* In-cluster S3 endpoint URL */}}
{{- define "geocodes.s3.endpoint" -}}
{{- printf "http://%s:8333" (include "geocodes.s3.serviceHost" .) }}
{{- end }}

{{/*
S3 credential env vars: (dict "root" $ "existingSecret" "" "accessVar" "S3KEY" "secretVar" "S3SECRET")
Reads accessKey/secretKey from existingSecret, or falls back to the in-cluster S3 credentials.
*/}}
{{- define "geocodes.s3CredentialEnv" -}}
{{- if .existingSecret }}
- name: {{ .accessVar }}
  valueFrom:
    secretKeyRef:
      name: {{ .existingSecret }}
      key: accessKey
- name: {{ .secretVar }}
  valueFrom:
    secretKeyRef:
      name: {{ .existingSecret }}
      key: secretKey
{{- else }}
- name: {{ .accessVar }}
  valueFrom:
    secretKeyRef:
      name: {{ include "geocodes.s3.secretName" .root }}
      key: accessKey
- name: {{ .secretVar }}
  valueFrom:
    secretKeyRef:
      name: {{ include "geocodes.s3.secretName" .root }}
      key: secretKey
{{- end }}
{{- end }}

{{/*
Traefik middleware annotation for an ingress.
(dict "root" $ "middlewares" (list "name1" "name2") "annotations" <component annotations>)
Merges global annotations, component annotations and, when enabled, the
traefik router.middlewares annotation.
*/}}
{{- define "geocodes.ingress.annotations" -}}
{{- $ann := merge (dict) (default (dict) .annotations) (default (dict) .root.Values.global.ingress.annotations) }}
{{- if and .root.Values.global.ingress.traefikMiddlewares .middlewares }}
{{- $refs := list }}
{{- range .middlewares }}
{{- $refs = append $refs (printf "%s-%s@kubernetescrd" $.root.Release.Namespace .) }}
{{- end }}
{{- $_ := set $ann "traefik.ingress.kubernetes.io/router.middlewares" (join "," $refs) }}
{{- end }}
{{- with $ann }}
annotations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Common ingress spec.
(dict "root" $ "host" "<host>" "path" "/" "service" "<svc>" "port" 80 "tlsSecret" "<name>")
*/}}
{{- define "geocodes.ingress.spec" -}}
{{- with .root.Values.global.ingress.className }}
ingressClassName: {{ . }}
{{- end }}
{{- if .root.Values.global.ingress.tls.enabled }}
tls:
  - hosts:
      - {{ .host | quote }}
    secretName: {{ .tlsSecret }}
{{- end }}
rules:
  - host: {{ .host | quote }}
    http:
      paths:
        - path: {{ .path }}
          pathType: Prefix
          backend:
            service:
              name: {{ .service }}
              port:
                number: {{ .port }}
{{- end }}
