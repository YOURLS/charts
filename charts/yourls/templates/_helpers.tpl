{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "yourls.mysql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mysql" "chartValues" .Values.mysql "context" $) -}}
{{- end -}}

{{/*
Return the proper YOURLS image name
*/}}
{{- define "yourls.image" -}}
{{- $imageRoot := .Values.image -}}
{{- if not .Values.image.tag }}
    {{- $tag := (dict "tag" .Chart.AppVersion) -}}
    {{- $imageRoot := merge .Values.image $tag -}}
{{- end -}}
{{- include "common.images.image" (dict "imageRoot" $imageRoot "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "yourls.metrics.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "yourls.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "yourls.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the MySQL Hostname
*/}}
{{- define "yourls.databaseHost" -}}
{{- if .Values.mysql.enabled }}
    {{- if eq .Values.mysql.architecture "replication" }}
        {{- printf "%s-primary" (include "yourls.mysql.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "yourls.mysql.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MySQL Port
*/}}
{{- define "yourls.databasePort" -}}
{{- if .Values.mysql.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MySQL Database Name
*/}}
{{- define "yourls.databaseName" -}}
{{- if .Values.mysql.enabled }}
    {{- printf "%s" .Values.mysql.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MySQL User
*/}}
{{- define "yourls.databaseUser" -}}
{{- if .Values.mysql.enabled }}
    {{- printf "%s" .Values.mysql.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MySQL Secret Name
*/}}
{{- define "yourls.databaseSecretName" -}}
{{- if .Values.mysql.enabled }}
    {{- if .Values.mysql.auth.existingSecret -}}
        {{- printf "%s" .Values.mysql.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "yourls.mysql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the YOURLS Site
*/}}
{{- define "yourls.site" -}}
    {{- printf "%s://%s" .Values.yourls.scheme .Values.yourls.domain -}}
{{- end -}}

{{/*
Return the YOURLS Secret Name
*/}}
{{- define "yourls.secretName" -}}
{{- if .Values.yourls.existingSecret }}
    {{- printf "%s" .Values.yourls.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "yourls.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "yourls.validateValues.database" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of YOURLS - Database */}}
{{- define "yourls.validateValues.database" -}}
{{- if and (not .Values.mysql.enabled) (or (empty .Values.externalDatabase.host) (empty .Values.externalDatabase.port) (empty .Values.externalDatabase.database)) -}}
yourls: database
   You disable the MySQL installation but you did not provide the required parameters
   to use an external database. To use an external database, please ensure you provide
   (at least) the following values:

       externalDatabase.host=DB_SERVER_HOST
       externalDatabase.database=DB_NAME
       externalDatabase.port=DB_SERVER_PORT
{{- end -}}
{{- end -}}
