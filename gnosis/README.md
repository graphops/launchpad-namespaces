

# Gnosis Namespace

This *Namespace* provides a suitable stack to operate Gnosis mainnet archive nodes.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Releases
- [nethermind](https://github.com/NethermindEth/nethermind)<br>
Nethermind is a high-performance, highly configurable full Ethereum protocol execution client built on .NET that runs on Linux, Windows, and macOS, and supports Clique, Aura, and Ethash.
- [nimbus](https://github.com/status-im/nimbus-eth2)<br>
Nimbus-eth2 is an extremely efficient consensus layer (eth2) client implementation.
- [proxyd](https://github.com/ethereum-optimism/optimism/tree/develop/proxyd)<br>
Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.

## Features

- Actively maintained by [![GraphOps](https://avatars.githubusercontent.com/u/85314764?s=12&v=4) *GraphOps*](https://graphops.xyz) [and contributors](/graphs/contributors)
- Common values interfaces across all namespaces
- Flexible and adaptable, allowing defaults to be overriden
- Two release channels: `stable` and `canary`
- A large selection of Namespaces (listed below)

## Quickstart

> **Note**
> [*Launchpad Starter*](https://github.com/graphops/launchpad-starter) is a great way to make use of *Namespaces* and worth checking out as a starting point for every new *Launchpad* deployment.

To use *Namespaces* you will require both a [*Kubernetes*](https://kubernetes.io) cluster and [*Helmfile*](https://github.com/helmfile/helmfile).
As such:
- Make sure your *Kubernetes* *Cluster* is in order and your environment has the *kubeconfig* context adequately setup
- Install *helmfile*, upstream guidance available here: [*Helmfile* Installation](https://github.com/helmfile/helmfile#installation)
– Install *kustomize*, upstream guidance availabe here: [*Kustomize* Installation](https://kubectl.docs.kubernetes.io/installation/kustomize/). Although `launchpad–namespaces` doesn't explicitly use *kustomize*, it is a dependencie for utilising *helmfile* features.

Next, setup an `helmfile.yaml` file that makes use of the gnosis *Namespace* by creating it with the following contents:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@gnosis/helmfile.yaml?ref=gnosis-latest
    selectorsInherited: true
```

> **Note**
> On the path to the helmfile, you can use the query string's ref `(?ref=gnosis-latest)` to track one of the release streams: `stable` and `canary`, pin to a specific version or just track a particular major or minor semantic version.
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@gnosis/helmfile.yaml?ref=gnosis-latest
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@gnosis/helmfile.yaml?ref=gnosis-latest
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@gnosis/helmfile.yaml?ref=gnosis-latest
    selectorsInherited: true
    values:
      <gnosis values>
  - path: git::https://github.com/graphops/launchpad-namespaces.git@<other namespace>/helmfile.yaml?ref=<other namespace>-latest
    selectorsInherited: true
    values:
      <other values>
```

## Values

| Key | Type | Default | Description |
| :--- | :---: | :--- | :--- |
annotations | object |  | Add annotations to release resources on this namespace |
flavor | string |  | suitable defaults for a mainnet archive node |
kubeVersion | string |  | Specifies the kubernetes API version, useful in helm templating environment |
labels | object |  | Adds helmfile labels to releases on this namespace |
nethermind | object |  |  |
nethermind.mergeValues | boolean | true |  |
nethermind.values | (object *or* list of objects) |  |  |
nimbus | object |  |  |
nimbus.mergeValues | boolean | true |  |
nimbus.values | (object *or* list of objects) |  |  |
proxyd | object |  |  |
proxyd.mergeValues | boolean | true |  |
proxyd.values | (object *or* list of objects) |  |  |
resourceLabels | object |  | Adds labels to release resources on this namespace |
targetNamespace | string | gnosis-mainnet | the default is gnosis-<flavor> |
helmDefaults | object |  |  |
helmDefaults.args | list of strings |  |  |
helmDefaults.cleanupOnFail | boolean |  |  |
helmDefaults.createNamespace | boolean |  |  |
helmDefaults.force | boolean |  |  |
helmDefaults.historyMax | number | 10 | limit the maximum number of revisions saved per release. Use 0<br>for no limit. |
helmDefaults.kubeContext | string |  |  |
helmDefaults.recreatePods | boolean |  |  |
helmDefaults.tillerNamespace | string |  |  |
helmDefaults.tillerless | boolean |  |  |
helmDefaults.timeout | number |  |  |
helmDefaults.tls | boolean |  |  |
helmDefaults.tlsCACert | string |  |  |
helmDefaults.tlsCert | string |  |  |
helmDefaults.tlsKey | string |  |  |
helmDefaults.verify | boolean |  |  |
helmDefaults.wait | boolean |  |  |
helmDefaults.waitForJobs | boolean |  |  |

