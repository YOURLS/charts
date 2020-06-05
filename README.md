# YOURLS using Helm

> The official [Helm](https://helm.sh) Charts repository for [YOURLS](https://yourls.org).

[![Build Status](https://github.com/YOURLS/charts/workflows/Charts%20CI/badge.svg)](https://github.com/YOURLS/charts/actions)
[![Chart Version](https://img.shields.io/badge/dynamic/yaml.svg?color=blue&label=chart&prefix=v&query=entries.yourls%5B0%5D.version&url=https%3A%2F%2Fcharts.yourls.org%2Findex.yaml)](https://hub.helm.sh/charts/yourls/yourls)

## Getting Started

1. **Install Helm**  
   Get the latest [Helm release](https://helm.sh/docs/intro/install/).

2. **Add YOURLS Helm Chart repository**  
   ```console
   helm repo add yourls https://charts.yourls.org/
   helm repo update
   ```

3. **Install a chart**  
   See docs on your preferred sources:
   * [Charts docs on Helm Hub](https://hub.helm.sh/charts/yourls)
   * [Charts respective READMEs](charts)
   * ```
     helm search yourls
     ```
