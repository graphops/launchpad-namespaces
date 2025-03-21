

# Graph Namespace

This *Namespace* provides the necessary software to run a Graph Node and participate
in the Graph Protocol Network

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Releases
- [graph-database](https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector)<br>
Manage Raw Kubernetes Resources using Helm
- [graph-network-indexer](https://github.com/graphprotocol/indexer)<br>
Graph protocol indexer components
- [graph-node](https://github.com/graphprotocol/graph-node)<br>
Graph Node is an open source Rust implementation that event sources the Ethereum blockchain to deterministically update a data store that can be queried via the GraphQL endpoint.
- [graph-operator-mnemonic](https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector)<br>
Manage Raw Kubernetes Resources using Helm
- [graph-toolbox](https://github.com/graphops/docker-builds/tree/main/dockerfiles/graph-toolbox)<br>
Utility kit for interacting and managing the Graph indexer stack.
- [subgraph-radio](https://github.com/graphops/subgraph-radio)<br>
Gossip about Subgraphs with other Graph Protocol Indexers

## Features

- Actively maintained by [![GraphOps](https://avatars.githubusercontent.com/u/85314764?s=12&v=4) *GraphOps*](https://graphops.xyz) [and contributors](https://github.com/graphops/launchpad-namespaces/graphs/contributors)
- Common values interfaces across all namespaces
- Flexible and adaptable, allowing defaults to be overridden
- Two release channels: `stable` and `canary`
- A large selection of Namespaces (listed below)

## Quickstart

> **Note**
> [*Launchpad Starter*](https://github.com/graphops/launchpad-starter) is a great way to make use of *Namespaces* and worth checking out as a starting point for every new *Launchpad* deployment.

To use *Namespaces* you will require both a [*Kubernetes*](https://kubernetes.io) cluster and [*Helmfile*](https://github.com/helmfile/helmfile).
As such:
- Make sure your *Kubernetes* *Cluster* is in order and your environment has the *kubeconfig* context adequately setup
- Install *helmfile*, upstream guidance available here: [*Helmfile* Installation](https://github.com/helmfile/helmfile#installation)
– Install *kustomize*, upstream guidance available here: [*Kustomize* Installation](https://kubectl.docs.kubernetes.io/installation/kustomize/). Although `launchpad–namespaces` doesn't explicitly use *kustomize*, it is a dependency for utilising *helmfile* features.

Next, setup an `helmfile.yaml` file that makes use of the Graph *Namespace* by creating it with the following contents:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@graph/helmfile.yaml?ref=graph-latest
    selectorsInherited: true
```

> **Note**
> On the path to the helmfile, you can use the query string's ref `(?ref=graph-latest)` to track one of the release streams: `stable` and `canary`, pin to a specific version or just track a particular major or minor semantic version.
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@graph/helmfile.yaml?ref=graph-latest
    selectorsInherited: true
    values:
      targetNamespace: "i-choose-my-own-namespace"
      labels:
        awesome.label.key/stuff: "yes"
        awesome.label.key/thing: "kind-of-thing"
```

where we add some labels to this *Namespace* releases, and set it to be deployed on cluster namespace different from default.

You can also easily override values for every release, like so:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@graph/helmfile.yaml?ref=graph-latest
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@graph/helmfile.yaml?ref=graph-latest
    selectorsInherited: true
    values:
      <graph values>
  - path: git::https://github.com/graphops/launchpad-namespaces.git@<other namespace>/helmfile.yaml?ref=<other namespace>-latest
    selectorsInherited: true
    values:
      <other values>
```

## Values

| Key | Type | Default | Description |
| :--- | :---: | :--- | :--- |
annotations | object |  | Add annotations to release resources on this namespace |
features | list of strings | [node, network-indexer, toolbox, database, subgraph-radio] | *enum of:&nbsp;&nbsp;(node \| network-indexer \| toolbox \| database \| subgraph-radio)* |
flavor | string |  |  |
graph&#8209;database | object |  |  |
graph&#8209;database.annotations | object |  | Add annotations to resources on this release |
graph&#8209;database.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
graph&#8209;database.chartVersion | string |  | Specify a specific chart version to use for this release |
graph&#8209;database.labels | object |  | Adds helmfile labels to this release |
graph&#8209;database.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
graph&#8209;database.resourceLabels | object |  | Adds labels to resources on this release |
graph&#8209;database.values | (object *or* list of objects) |  | Pass values to the release helm chart |
graph&#8209;network&#8209;indexer | object |  |  |
graph&#8209;network&#8209;indexer.annotations | object |  | Add annotations to resources on this release |
graph&#8209;network&#8209;indexer.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
graph&#8209;network&#8209;indexer.chartVersion | string |  | Specify a specific chart version to use for this release |
graph&#8209;network&#8209;indexer.labels | object |  | Adds helmfile labels to this release |
graph&#8209;network&#8209;indexer.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
graph&#8209;network&#8209;indexer.resourceLabels | object |  | Adds labels to resources on this release |
graph&#8209;network&#8209;indexer.values | (object *or* list of objects) |  | Pass values to the release helm chart |
graph&#8209;node | object |  |  |
graph&#8209;node.annotations | object |  | Add annotations to resources on this release |
graph&#8209;node.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
graph&#8209;node.chartVersion | string |  | Specify a specific chart version to use for this release |
graph&#8209;node.labels | object |  | Adds helmfile labels to this release |
graph&#8209;node.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
graph&#8209;node.resourceLabels | object |  | Adds labels to resources on this release |
graph&#8209;node.values | (object *or* list of objects) |  | Pass values to the release helm chart |
graph&#8209;operator&#8209;mnemonic | object |  |  |
graph&#8209;operator&#8209;mnemonic.annotations | object |  | Add annotations to resources on this release |
graph&#8209;operator&#8209;mnemonic.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
graph&#8209;operator&#8209;mnemonic.chartVersion | string |  | Specify a specific chart version to use for this release |
graph&#8209;operator&#8209;mnemonic.labels | object |  | Adds helmfile labels to this release |
graph&#8209;operator&#8209;mnemonic.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
graph&#8209;operator&#8209;mnemonic.resourceLabels | object |  | Adds labels to resources on this release |
graph&#8209;operator&#8209;mnemonic.values | (object *or* list of objects) |  | Pass values to the release helm chart |
graph&#8209;toolbox | object |  |  |
graph&#8209;toolbox.annotations | object |  | Add annotations to resources on this release |
graph&#8209;toolbox.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
graph&#8209;toolbox.chartVersion | string |  | Specify a specific chart version to use for this release |
graph&#8209;toolbox.labels | object |  | Adds helmfile labels to this release |
graph&#8209;toolbox.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
graph&#8209;toolbox.resourceLabels | object |  | Adds labels to resources on this release |
graph&#8209;toolbox.values | (object *or* list of objects) |  | Pass values to the release helm chart |
kubeVersion | string |  | Specifies the kubernetes API version, useful in helm templating environment |
labels | object |  | Adds helmfile labels to releases on this namespace |
resourceLabels | object |  | Adds labels to release resources on this namespace |
subgraph&#8209;radio | object |  |  |
subgraph&#8209;radio.annotations | object |  | Add annotations to resources on this release |
subgraph&#8209;radio.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
subgraph&#8209;radio.chartVersion | string |  | Specify a specific chart version to use for this release |
subgraph&#8209;radio.labels | object |  | Adds helmfile labels to this release |
subgraph&#8209;radio.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
subgraph&#8209;radio.resourceLabels | object |  | Adds labels to resources on this release |
subgraph&#8209;radio.values | (object *or* list of objects) |  | Pass values to the release helm chart |
targetNamespace | string | graph-arbitrum-one | the default is graph-<flavor> |
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

