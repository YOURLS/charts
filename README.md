# YOURLS using Helm

> The official [Helm](https://helm.sh) Charts repository for [YOURLS](https://yourls.org).

[![Build Status](https://github.com/YOURLS/charts/workflows/Charts%20CI/badge.svg)](https://github.com/YOURLS/charts/actions)
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/yourls)](https://artifacthub.io/packages/search?repo=yourls)
[![Chart Version](https://img.shields.io/badge/dynamic/yaml.svg?color=blue&label=chart&prefix=v&query=entries.yourls%5B0%5D.version&url=https%3A%2F%2Fcharts.yourls.org%2Findex.yaml)](https://artifacthub.io/packages/helm/yourls/yourls)

## Getting Started

1. **Install Helm**  
    Get the latest [Helm release](https://helm.sh/docs/intro/install/).

2. **Add YOURLS Helm Chart repository**  
    ```sh
    helm repo add yourls https://charts.yourls.org/
    helm repo update
    ```

3. **Install a chart**  
    See docs on your preferred sources:
    * [Charts docs on Artifact Hub](https://artifacthub.io/packages/search?org=yourls)
    * [Charts respective READMEs](charts)
    * [Charts discovery](https://helm.sh/docs/helm/helm_search/)
      ```sh
      helm search yourls
      ```
