{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "yourls.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "yourls.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "yourls.mysql.fullname" -}}
{{- printf "%s-%s" .Release.Name "mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper YOURLS image name
*/}}
{{- define "yourls.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "yourls.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "metrics.image" -}}
{{- $registryName :=  .Values.metrics.image.registry -}}
{{- $repositoryName := .Values.metrics.image.repository -}}
{{- $tag := .Values.metrics.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return secret name to be used for application secrets
*/}}
{{- define "yourls.applicationSecret" -}}
{{- $fullName := include "yourls.fullname" . -}}
{{- default $fullName .Values.yourls.passwordExistingSecret | quote -}}
{{- end -}}

{{/*
Return secret name to be used for external db secrets
*/}}
{{- define "yourls.dbSecret" -}}
{{- $fullName := printf "%s-%s" .Chart.Name "externaldb" -}}
{{- default $fullName .Values.db.existingSecret | quote -}}
{{- end -}}

{{/*
Return the MySQL Hostname
*/}}
{{- define "yourls.databaseHost" -}}
{{- if .Values.mysql.enabled }}
    {{- if eq .Values.mysql.architecture "replication" }}
        {{- printf "%s-%s" (include "yourls.mysql.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "yourls.mysql.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.db.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MySQL Port
*/}}
{{- define "yourls.databasePort" -}}
{{- if .Values.mysql.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.db.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MySQL Database Name
*/}}
{{- define "yourls.databaseName" -}}
{{- if .Values.mysql.enabled }}
    {{- printf "%s" .Values.mysql.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.db.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MySQL User
*/}}
{{- define "yourls.databaseUser" -}}
{{- if .Values.mysql.enabled }}
    {{- printf "%s" .Values.mysql.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.db.user -}}
{{- end -}}
{{- end -}}
