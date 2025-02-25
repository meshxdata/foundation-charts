{{/*
Default name of the Chart (and its resources) is defined in the Chart.yaml.
However, this name may be overriden to avoid conflict if more than one application use this chart.
*/}}
{{- define "hive-metastore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hive-metastore.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hive-metastore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*

*/}}
{{- define "hive-metastore.init-warehouse-jobname" -}}
{{- printf "%s-%s-%s" .Release.Name "migrations" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hive-metastore.labels" -}}
helm.sh/chart: {{ include "hive-metastore.chart" . }}
{{ include "hive-metastore.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "hive-metastore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hive-metastore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "hive-metastore.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hive-metastore.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "hive-metastore.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Add variables to configure database values
*/}}
{{- define "hive-metastore.postgresql.host" -}}
{{- ternary (include "hive-metastore.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add variables to configure database values
*/}}
{{- define "hive-metastore.postgresql.username" -}}
{{- ternary .Values.postgresql.auth.username .Values.externalDatabase.username .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add variables to configure database values
*/}}
{{- define "hive-metastore.postgresql.name" -}}
{{- ternary .Values.postgresql.auth.database .Values.externalDatabase.database .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add variables to configure database values
*/}}
{{- define "hive-metastore.postgresql.port" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add variables to configure database values
*/}}
{{- define "hive-metastore.postgresql.url" -}}
{{- $host := (include "hive-metastore.postgresql.host" .) -}}
{{- $dbName := (include "hive-metastore.postgresql.name" .) -}}
{{- $port := (include "hive-metastore.postgresql.port" . ) -}}
{{- printf "%s:%s/%s" $host $port $dbName -}}
{{- end -}}



{{/*
Get the database credentials secret.
*/}}
{{- define "hive-metastore.postgresql.secretName" -}}
{{- if and (.Values.postgresql.enabled) (not .Values.postgresql.auth.existingSecret) -}}
    {{- printf "%s" (include "hive-metastore.postgresql.fullname" .) -}}
{{- else if and (.Values.postgresql.enabled) (.Values.postgresql.auth.existingSecret) -}}
    {{- printf "%s" .Values.postgresql.auth.existingSecret -}}
{{- else }}
    {{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.existingSecret) -}}
        {{ printf "%s-%s" (include "hive-metastore.name" . ) "externaldb" }}
    {{- else if .Values.externalDatabase.existingSecret -}}
        {{- printf "%s" .Values.externalDatabase.existingSecret -}}
    {{- end -}}
{{- end -}}
{{- end -}}


{{/*
Get the database user-password key.
*/}}
{{- define "hive-metastore.postgresql.userPasswordKey" -}}
{{- if .Values.postgresql.auth.existingSecret }}
    {{- if or (empty (include "hive-metastore.postgresql.username" .)) (eq (include "hive-metastore.postgresql.username" .) "postgres") }}
        {{- printf "%s" (include "hive-metastore.postgresql.adminPasswordKey" .) -}}
    {{- else -}}
        {{- if .Values.postgresql.auth.secretKeys.userPasswordKey }}
            {{- printf "%s" (tpl .Values.postgresql.auth.secretKeys.userPasswordKey $) -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- ternary "password" "postgres-password" (and (not (empty (include "hive-metastore.postgresql.username" .))) (ne (include "hive-metastore.postgresql.username" .) "postgres")) -}}
{{- end -}}
{{- end -}}

{{/*
Get the admin-password key.
*/}}
{{- define "hive-metastore.postgresql.adminPasswordKey" -}}
{{- if .Values.postgresql.auth.existingSecret }}
    {{- if .Values.postgresql.auth.secretKeys.adminPasswordKey }}
        {{- printf "%s" (tpl .Values.postgresql.auth.secretKeys.adminPasswordKey $) -}}
    {{- end -}}
{{- else -}}
    {{- "postgres-password" -}}
{{- end -}}
{{- end -}}

{{/* 
Define imageTag
*/}}
{{- define "hive-metastore.imageTag" -}}
{{- if .Values.hiveMetastore.image.tag }}
    {{- printf "%s" .Values.hiveMetastore.image.tag }}
{{- else }}
    {{- printf "%s" .Chart.AppVersion }}
{{- end }}
{{- end }}
