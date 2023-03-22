# YOURLS using Helm

> The official [Helm](https://helm.sh) charts repository for [YOURLS](https://yourls.org).

[![Build Status](https://github.com/YOURLS/charts/actions/workflows/ci.yml/badge.svg)](https://github.com/YOURLS/charts/actions/workflows/ci.yml)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/yourls)](https://artifacthub.io/packages/search?repo=yourls)
[![Awesome YOURLS](https://img.shields.io/badge/Awesome-YOURLS-C5A3BE)](https://github.com/YOURLS/awesome-yourls)

## About

This is the Git repository of the official Helm charts for YOURLS.

|      Chart      |                                                                                                           Version                                                                                                            |
|:---------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| `yourls/yourls` | [![Chart Version](https://img.shields.io/badge/dynamic/json?label=yourls&query=version&url=https%3A%2F%2Fartifacthub.io%2Fapi%2Fv1%2Fpackages%2Fhelm%2Fyourls%2Fyourls)](https://artifacthub.io/packages/helm/yourls/yourls) |

## Usage

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

## License

This project is licensed under [MIT License](LICENSE).
