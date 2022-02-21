{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "function.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{/*
Return the proper YOURLS image name
*/}}
{{- define "function.image" -}}
{{- $imageRoot := .Values.image -}}
{{- if not .Values.image.tag }}
    {{- $tag := (dict "tag" .Chart.AppVersion) -}}
    {{- $imageRoot := merge .Values.image $tag -}}
{{- end -}}
{{- include "common.images.image" (dict "imageRoot" $imageRoot "global" .Values.global) -}}
{{- end -}}

{{/*
Return the Function Secret Name
*/}}
{{- define "function.secretName" -}}
{{- if .Values.function.existingSecret }}
    {{- printf "%s" .Values.function.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis&trade; hostname
*/}}
{{- define "function.redisHost" -}}
{{- if .Values.redis.enabled }}
    {{- printf "%s-master" (include "function.redis.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis&trade; port
*/}}
{{- define "function.redisPort" -}}
{{- if .Values.redis.enabled }}
    {{- printf "6379" | quote -}}
{{- else -}}
    {{- .Values.externalDatabase.port | quote -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object for Redis&trade; should be created
*/}}
{{- define "function.redis.createSecret" -}}
{{- if and (not .Values.redis.enabled) (not .Values.externalDatabase.existingSecret) .Values.externalDatabase.password }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis&trade; secret name
*/}}
{{- define "function.redis.secretName" -}}
{{- if .Values.redis.enabled }}
    {{- if .Values.redis.auth.existingSecret }}
        {{- printf "%s" .Values.redis.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "function.redis.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret }}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-redis" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis&trade; secret key
*/}}
{{- define "function.redis.secretPasswordKey" -}}
{{- if and .Values.redis.enabled .Values.redis.auth.existingSecret }}
    {{- required "You need to provide existingSecretPasswordKey when an existingSecret is specified in redis" .Values.redis.auth.existingSecretPasswordKey | printf "%s" }}
{{- else if and (not .Values.redis.enabled) .Values.externalDatabase.existingSecret }}
    {{- required "You need to provide existingSecretPasswordKey when an existingSecret is specified in redis" .Values.externalDatabase.existingSecretPasswordKey | printf "%s" }}
{{- else -}}
    {{- printf "redis-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return whether Redis&trade; uses password authentication or not
*/}}
{{- define "function.redis.auth.enabled" -}}
{{- if or (and .Values.redis.enabled .Values.redis.auth.enabled) (and (not .Values.redis.enabled) (or .Values.externalDatabase.password .Values.externalDatabase.existingSecret)) }}
    {{- true -}}
{{- end -}}
{{- end -}}
