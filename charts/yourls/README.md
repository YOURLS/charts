# YOURLS

[YOURLS](https://yourls.org/) is a set of PHP scripts that will allow you to run Your Own URL Shortener.

## TL;DR;

```console
$ helm install yourls/yourls
```

## Introduction

This chart bootstraps a [YOURLS](https://hub.docker.com/_/yourls) deployment on a [Kubernetes](https://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager.

It also packages [MySQL chart](https://artifacthub.io/packages/helm/bitnami/mysql) which is required for
bootstrapping a MySQL deployment for the database requirements of the YOURLS application.

Charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.18+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release yourls/yourls
```

The command deploys YOURLS on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Values definition are available in the [`values.schema.json`](values.schema.json) file.

The parameters map to the env variables defined in [YOURLS](https://hub.docker.com/_/yourls).
For more information please refer to the [YOURLS](https://hub.docker.com/_/yourls) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set yourls.username=admin,yourls.password=password,mysql.mysqlRootPassword=secretpassword \
    yourls/yourls
```

The above command sets the YOURLS administrator account username and password to `admin` and `password` respectively.
Additionally, it sets the MySQL `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml yourls/yourls
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [YOURLS](https://hub.docker.com/_/yourls) image stores the YOURLS data and configurations at the `/yourls` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Using an external database

Sometimes you may want to have YOURLS connect to an external database rather than installing one inside your cluster, e.g.
to use a managed database service, or use run a single database server for all your applications.
To do this, the chart allows you to specify credentials for an external database under the [`db` parameter](#configuration).
You should also disable the MySQL installation with the `mysql.enabled` option. For example:

```console
$ helm install yourls/yourls \
    --set mysql.enabled=false,db.host=myexternalhost:3306,db.user=myuser,db.password=mypassword,db.database=mydatabase
```

Note also if you disable MySQL per above you MUST supply values for the `db` connection.

## Ingress

This chart provides support for ingress resources. If you have an
ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress)
or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize
the ingress controller to serve your YOURLS application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts

Most likely you will only want to have one hostname that maps to this
YOURLS installation, however, it is possible to have more than one
host.  To facilitate this, the `ingress.hosts` object is an array.

For each item, please indicate a `name`, `tls`, `tlsSecret`, and any
`annotations` that you may want the ingress controller to know about.

Indicating TLS will cause YOURLS to generate HTTPS URLs, and
YOURLS will be connected to at port 443.  The actual secret that
`tlsSecret` references do not have to be generated by this chart.
However, please note that if TLS is enabled, the ingress record will not
work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md).
Not all annotations are supported by all ingress controllers, but this
document does a good job of indicating which annotation is supported by
many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the
ingress controller, however, this is not required.  There are three
common use cases:

* helm generates/manages certificate secrets
* user generates/manages certificates separately
* an additional tool (like [kube-lego](https://kubeapps.com/charts/stable/kube-lego))
manages the secrets for the application

In the first two cases, one will need a certificate and a key.  We would
expect them to look like this:

* certificate files should look like (and there can be more than one
certificate if there is a certificate chain)

```
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```
* keys should look like:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
````

If you are going to use Helm to manage the certificates, please copy
these values into the `certificate` and `key` values for a given
`ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please
know that you can create a TLS secret by doing the following:

```
kubectl create secret tls yourls.local-tls --key /path/to/key.key --cert /path/to/cert.crt
```

Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls)
for more information.
