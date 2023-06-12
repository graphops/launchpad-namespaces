# Launchpad Namespaces

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction

Launchpad Namespaces, part of Launchpad Toolkit, is... and aims too....

- Actively maintained by [GraphOps](https://graphops.xyz) 

## Features

- Common values interfaces
- Two release channels
- list of namespaces?

## Getting Started

Please see the [Quick Start](https://docs.graphops.xyz/launchpad/quick-start) guide in the [Documentation](https://docs.graphops.xyz/launchpad/intro).

- example usage with helmfile

## Updates

- use version bumping tools
- latest and latest-canary moving tags

## Namespaces

The following namespaces are supported:

### [ethereum](https://github.com/graphops/launchpad-namespaces/eth-erigon)
For deploying ethereum mainnet and göerli archive nodes

- [erigon](https://github.com/ledgerwatch/erigon)
Erigon is an implementation of Ethereum (execution client with light client for consensus layer), on the efficiency frontier.
- [nimbus](https://github.com/status-im/nimbus-eth2)
Nimbus-eth2 is an extremely efficient consensus layer (eth2) client implementation.
- [proxyd](https://github.com/ethereum-optimism/optimism/tree/develop/proxyd)
Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.
### [ingress](https://github.com/graphops/launchpad-namespaces/ingress)
Adds ingress support and certificate management on kubernetes

- [cert-manager](https://github.com/cert-manager/cert-manager)
cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates.
- [cert-manager-resources](https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector)
Manage Raw Kubernetes Resources using Helm
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx)
ingress-nginx is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.
### [monitoring](https://github.com/graphops/launchpad-namespaces/monitoring)
Adds software for log and metrics collection and visualization, as well as alarmistic.

- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules
- [loki](https://github.com/grafana/helm-charts/tree/main/charts/loki-distributed)
Helm chart for Grafana Loki in microservices mode
- [node-problem-detector](https://github.com/deliveryhero/helm-charts/tree/master/stable/node-problem-detector)
This chart installs a node-problem-detector daemonset. This tool aims to make various node problems visible to the upstream layers in cluster management stack.
- [promtail](https://github.com/grafana/helm-charts/tree/main/charts/promtail)
Promtail is an agent which ships the contents of local logs to a Loki instance
### [postgres operator](https://github.com/graphops/launchpad-namespaces/postgres-operator)
Extends your Kubernetes cluster with custom resources for easilly creating and managing Postgres databases

- [postgres-operator](https://github.com/zalando/postgres-operator)
The Postgres Operator delivers an easy to run highly-available PostgreSQL clusters on Kubernetes (K8s) powered by Patroni.
### [sealed secrets](https://github.com/graphops/launchpad-namespaces/sealed-secrets)
...TODO...

- [sealed-secrets](https://github.com/bitnami/charts/tree/main/bitnami/sealed-secrets)
Sealed Secrets are 'one-way' encrypted K8s Secrets that can be created by anyone, but can only be decrypted by the controller running in the target cluster recovering the original object.
### [storage](https://github.com/graphops/launchpad-namespaces/storage)
...TODO...

- [openebs](https://github.com/openebs/openebs)
OpenEBS is the leading open-source example of a category of cloud native storage solutions sometimes called Container Attached Storage.
- [openebs-rawfile-localpv](https://github.com/graphops/launchpad-charts/tree/main/charts/openebs-rawfile-localpv)
RawFile Driver Container Storage Interface
- [openebs-rawfile-storageclass](https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector)
Manage Raw Kubernetes Resources using Helm
- [openebs-zfs-localpv](https://github.com/openebs/zfs-localpv/tree/b70fb1e847b8c9ba32e3fd8cba877767686f6b26)
CSI driver for provisioning Local PVs backed by ZFS and more.
- [openebs-zfs-storageclass](https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector)
Manage Raw Kubernetes Resources using Helm


## Contributing

We welcome and appreciate your contributions! Please see the [Contributor Guide](/CONTRIBUTING.md), [Code Of Conduct](/CODE_OF_CONDUCT.md) and [Security Notes](/SECURITY.md) for this repository.

## See also

- [`graphops/launchpad-charts`](https://github.com/graphops/launchpad-charts)
- [`graphops/launchpad-starter`](https://github.com/graphops/launchpad-starter)

