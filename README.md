# Launchpad Namespaces

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction

*Launchpad Namespaces*, part of the *Launchpad Toolkit*, leverages [*Helmfile*](https://github.com/helmfile/helmfile) to offer a declarative way for deploying and managing functionally related bundles of [helm charts](https://github.com/helm/helm) (called *releases* in *helmfile*).

It aims to:
- be easy to use, while extensible and adaptable
- provide sensible working defaults that can always be overriden
- service the requirements of Launchpad and GraphOps

## Features

- Actively maintained by [![GraphOps](https://avatars.githubusercontent.com/u/85314764?s=12&v=4) *GraphOps*](https://graphops.xyz) [and contributors](/graphs/contributors)
- Common values interfaces across all namespaces
- Flexible and adaptable, allowing defaults to be overriden
- Two release channels: `main` and `canary`
- A large selection of Namespaces (listed below)

## Getting Started

> **Note**
> [~~*Launchpad Starter*~~ support for *Namespaces* will be available soon](https://github.com/graphops/launchpad-starter) is a great way to make use of *Namespaces* and worth checking out

To use *Namespaces* you will require both a [*Kubernetes*](https://kubernetes.io) cluster and [*Helmfile*](https://github.com/helmfile/helmfile).
As such:
- Make sure your *Kubernetes* *Cluster* is in order and your environment has the *kubeconfig* context adequately setup
- Install *helmfile*, upstream guidance available here: [*Helmfile* Installation](https://github.com/helmfile/helmfile#installation)

Next, setup an `helmfile.yaml` file that makes use of the storage *Namespace* by creating it with the following contents:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml?ref=storage:latest
    selectorsInherited: true
```

> **Note**
> On the path to the helmfile, you can use the query string's ref `(?ref=storage:latest)` to track one of the release streams: `main` and `canary`, pin to a specific version or just track a particular major or minor semantic version.
> For more on this, check the [*Updates*](/README.md#Updates) section

This is a very minimalist helmfile but enough to get it done.
Proceed by running `helmfile`:
```shell
helmfile sync -i
```

After some output, you should be greeted by a prompt like this:
> Do you really want to sync?
>   Helmfile will sync all your releases, as shown above.
>
>  [y/n]:

Answer 'y' and hopefully the installation will conclude successfully.

### overriding namespace and releases' `values`

To customize the configuration and deployment, you can pass values to override the default helmfile configuration like so:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml?ref=storage:latest
    selectorsInherited: true
    values:
      targetNamespace: "i-choose-my-own-namespace"
      labels:
        awesome.label.key/stuff: "yes"
        awesome.label.key/thing: "kind-of-thing"
```

where we add some labels to this *Namespace* releases, and set it to be deployed on cluster namespace different from default.

You can also easilly override values for every release, like so:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml?ref=storage:latest
    selectorsInherited: true
    values:
      targetNamespace: "i-choose-my-own-namespace"
      labels:
        awesome.label.key/stuff: "yes"
        awesome.label.key/thing: "kind-of-thing"
      <release-name>:
        - akey: value
          bkey: value
```

Check out the *Namespaces* [list](/README.md#namespaces) below for release names, and each chart's folder for its specific values interface.

To use multiple namespaces on the same cluster, just add more items to the helmfiles array like so:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml?ref=storage:latest
    selectorsInherited: true
    values:
      <storage values>
  - path: git::https://github.com/graphops/launchpad-namespaces.git@<other namespace>/helmfile.yaml?ref=<other namespace>:latest
    selectorsInherited: true
    values:
      <other values>
```

## Updates

> **Warning**
> w.i.p: GitHub Workflows still being worked out
> this will be updated soon

## Namespaces

The following namespaces are supported:

### [:arbitrum](/arbitrum)
This *Namespace* provides a suitable stack to operate Arbitrum mainnet archive nodes.

- [arbitrum-classic](/arbitrum-classic)<br>
The old "classic" Arbitrum tech stack.
- [arbitrum-nitro](/arbitrum-nitro)<br>
Nitro is the latest iteration of the Arbitrum technology. It is a fully integrated, complete layer 2 optimistic rollup system, including fraud proofs, the sequencer, the token bridges, advanced calldata compression, and more.
- [proxyd](/proxyd)<br>
Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.
### [:avalanche](/avalanche)
This *Namespace* provides a suitable stack to operate Avalanche mainnet archive nodes.

- [avalanche](/avalanche)<br>
Node implementation for the Avalanche network - a blockchains platform with high throughput, and blazing fast transactions.
- [proxyd](/proxyd)<br>
Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.
### [:celo](/celo)
This *Namespace* provides a suitable stack to operate Celo mainnet archive nodes.

- [celo](/celo)<br>
Official golang implementation of the Celo blockchain
- [proxyd](/proxyd)<br>
Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.
### [:ethereum](/ethereum)
This *Namespace* provides a suitable stack to operate Ethereum mainnet and göerli archive nodes.

- [erigon](/erigon)<br>
Erigon is an implementation of Ethereum (execution client with light client for consensus layer), on the efficiency frontier.
- [nimbus](/nimbus)<br>
Nimbus-eth2 is an extremely efficient consensus layer (eth2) client implementation.
- [proxyd](/proxyd)<br>
Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.
### [:gnosis](/gnosis)
This *Namespace* provides a suitable stack to operate Gnosis mainnet archive nodes.

- [nethermind](/nethermind)<br>
Nethermind is a high-performance, highly configurable full Ethereum protocol execution client built on .NET that runs on Linux, Windows, and macOS, and supports Clique, Aura, and Ethash.
- [nimbus](/nimbus)<br>
Nimbus-eth2 is an extremely efficient consensus layer (eth2) client implementation.
- [proxyd](/proxyd)<br>
Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.
### [:graph](/graph)
This *Namespace* provides the necessary software to run a Graph Node and participate
in the Graph Protocol Network

- [graph-network-indexer](/graph-network-indexer)<br>
Graph protocol indexer components
- [graph-node](/graph-node)<br>
Graph Node is an open source Rust implementation that event sources the Ethereum blockchain to deterministically update a data store that can be queried via the GraphQL endpoint.
- [graph-toolbox](/graph-toolbox)<br>
Utility kit for interacting and managing the Graph indexer stack.
### [:ingress](/ingress)
This *Namespace* adds ingress support and certificate management on kubernetes

- [cert-manager](/cert-manager)<br>
cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates.
- [cert-manager-resources](/resource-injector)<br>
Manage Raw Kubernetes Resources using Helm
- [ingress-nginx](/ingress-nginx)<br>
ingress-nginx is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.
### [:monitoring](/monitoring)
This *Namespace* adds software for log and metrics collection and visualization, as well as alarmistic.

- [kube-prometheus-stack](/kube-prometheus-stack)<br>
Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules
- [loki](/loki-distributed)<br>
Helm chart for Grafana Loki in microservices mode
- [node-problem-detector](/node-problem-detector)<br>
This chart installs a node-problem-detector daemonset. This tool aims to make various node problems visible to the upstream layers in cluster management stack.
- [promtail](/promtail)<br>
Promtail is an agent which ships the contents of local logs to a Loki instance
### [:polygon](/polygon)
This *Namespace* provides a suitable stack to operate Polygon mainnet archive nodes.

- [erigon](/erigon)<br>
Erigon is an implementation of Ethereum (execution client with light client for consensus layer), on the efficiency frontier.
- [heimdall](/heimdall)<br>
Validator node for Matic Network.
- [proxyd](/proxyd)<br>
Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.
### [:postgres-operator](/postgres-operator)
This *Namespace* extends your Kubernetes cluster with custom resources for easilly creating and managing Postgres databases

- [postgres-operator](/postgres-operator)<br>
The Postgres Operator delivers an easy to run highly-available PostgreSQL clusters on Kubernetes (K8s) powered by Patroni.
### [:sealed-secrets](/sealed-secrets)
This *Namespace* provides a Kubernetes controller and tool for one-way encrypted Secrets

- [sealed-secrets](/sealed-secrets)<br>
Sealed Secrets are 'one-way' encrypted K8s Secrets that can be created by anyone, but can only be decrypted by the controller running in the target cluster recovering the original object.
### [:storage](/storage)
This *Namespace* uses [OpenEBS](https://openebs.io) to provide a software defined storage layer
suitable for stateful workloads that require low-latency access to the storage.

- [openebs](/openebs)<br>
OpenEBS is the leading open-source example of a category of cloud native storage solutions sometimes called Container Attached Storage.
- [openebs-rawfile-localpv](/openebs-rawfile-localpv)<br>
RawFile Driver Container Storage Interface
- [openebs-rawfile-storageclass](/resource-injector)<br>
Manage Raw Kubernetes Resources using Helm
- [openebs-zfs-localpv](/zfs-localpv)<br>
CSI driver for provisioning Local PVs backed by ZFS and more.
- [openebs-zfs-storageclass](/resource-injector)<br>
Manage Raw Kubernetes Resources using Helm


## Contributing

We welcome and appreciate your contributions! Please see the [Contributor Guide](/CONTRIBUTING.md), [Code Of Conduct](/CODE_OF_CONDUCT.md) and [Security Notes](/SECURITY.md) for this repository.

## See also

- [`graphops/launchpad-charts`](https://github.com/graphops/launchpad-charts)
- [`graphops/launchpad-starter`](https://github.com/graphops/launchpad-starter)

