

# Storage Namespace

This *Namespace* uses [OpenEBS](https://openebs.io) to provide a software defined storage layer
suitable for stateful workloads that require low-latency access to the storage.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Releases
- [openebs](https://github.com/openebs/openebs)<br>
OpenEBS is the leading open-source example of a category of cloud native storage solutions sometimes called Container Attached Storage.
- [openebs-rawfile-localpv](https://github.com/graphops/launchpad-charts/tree/main/charts/openebs-rawfile-localpv)<br>
RawFile Driver Container Storage Interface
- [openebs-rawfile-storageclass](https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector)<br>
Manage Raw Kubernetes Resources using Helm
- [openebs-zfs-localpv](https://github.com/openebs/zfs-localpv/tree/b70fb1e847b8c9ba32e3fd8cba877767686f6b26)<br>
CSI driver for provisioning Local PVs backed by ZFS and more.
- [openebs-zfs-snapclass](https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector)<br>
Manage Raw Kubernetes Resources using Helm
- [openebs-zfs-storageclass](https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector)<br>
Manage Raw Kubernetes Resources using Helm

## Features

- Actively maintained by [![GraphOps](https://avatars.githubusercontent.com/u/85314764?s=12&v=4) *GraphOps*](https://graphops.xyz) [and contributors](/graphs/contributors)
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

Next, setup an `helmfile.yaml` file that makes use of the storage *Namespace* by creating it with the following contents:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml?ref=storage-latest
    selectorsInherited: true
```

> **Note**
> On the path to the helmfile, you can use the query string's ref `(?ref=storage-latest)` to track one of the release streams: `stable` and `canary`, pin to a specific version or just track a particular major or minor semantic version.
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml?ref=storage-latest
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml?ref=storage-latest
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml?ref=storage-latest
    selectorsInherited: true
    values:
      <storage values>
  - path: git::https://github.com/graphops/launchpad-namespaces.git@<other namespace>/helmfile.yaml?ref=<other namespace>-latest
    selectorsInherited: true
    values:
      <other values>
```

## Values

| Key | Type | Default | Description |
| :--- | :---: | :--- | :--- |
annotations | object |  | Add annotations to releases on this namespace |
features | list of strings | [rawfile] | *enum of:&nbsp;&nbsp;(zfs \| rawfile)* |
kubeVersion | string |  | Specifies the kubernetes API version, useful in helm templating environment |
labels | object |  | Adds labels to releases on this namespace |
openebs | object |  |  |
openebs.annotations | object |  | Add annotations to resources on this release |
openebs.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
openebs.chartVersion | string |  | Specify a specific chart version to use for this release |
openebs.labels | object |  | Adds helmfile labels to this release |
openebs.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
openebs.values | (object *or* list of objects) |  | Pass values to the release helm chart |
openebs&#8209;rawfile&#8209;localpv | object |  |  |
openebs&#8209;rawfile&#8209;localpv.annotations | object |  | Add annotations to resources on this release |
openebs&#8209;rawfile&#8209;localpv.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
openebs&#8209;rawfile&#8209;localpv.chartVersion | string |  | Specify a specific chart version to use for this release |
openebs&#8209;rawfile&#8209;localpv.labels | object |  | Adds helmfile labels to this release |
openebs&#8209;rawfile&#8209;localpv.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
openebs&#8209;rawfile&#8209;localpv.values | (object *or* list of objects) |  | Pass values to the release helm chart |
openebs&#8209;rawfile&#8209;storageclass | object |  |  |
openebs&#8209;rawfile&#8209;storageclass.annotations | object |  | Add annotations to resources on this release |
openebs&#8209;rawfile&#8209;storageclass.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
openebs&#8209;rawfile&#8209;storageclass.chartVersion | string |  | Specify a specific chart version to use for this release |
openebs&#8209;rawfile&#8209;storageclass.labels | object |  | Adds helmfile labels to this release |
openebs&#8209;rawfile&#8209;storageclass.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
openebs&#8209;rawfile&#8209;storageclass.values | (object *or* list of objects) |  | Pass values to the release helm chart |
openebs&#8209;zfs&#8209;localpv | object |  |  |
openebs&#8209;zfs&#8209;localpv.annotations | object |  | Add annotations to resources on this release |
openebs&#8209;zfs&#8209;localpv.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
openebs&#8209;zfs&#8209;localpv.chartVersion | string |  | Specify a specific chart version to use for this release |
openebs&#8209;zfs&#8209;localpv.labels | object |  | Adds helmfile labels to this release |
openebs&#8209;zfs&#8209;localpv.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
openebs&#8209;zfs&#8209;localpv.values | (object *or* list of objects) |  | Pass values to the release helm chart |
openebs&#8209;zfs&#8209;snapclass | object |  |  |
openebs&#8209;zfs&#8209;snapclass.annotations | object |  | Add annotations to resources on this release |
openebs&#8209;zfs&#8209;snapclass.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
openebs&#8209;zfs&#8209;snapclass.chartVersion | string |  | Specify a specific chart version to use for this release |
openebs&#8209;zfs&#8209;snapclass.labels | object |  | Adds helmfile labels to this release |
openebs&#8209;zfs&#8209;snapclass.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
openebs&#8209;zfs&#8209;snapclass.values | (object *or* list of objects) |  | Pass values to the release helm chart |
openebs&#8209;zfs&#8209;storageclass | object |  |  |
openebs&#8209;zfs&#8209;storageclass.annotations | object |  | Add annotations to resources on this release |
openebs&#8209;zfs&#8209;storageclass.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
openebs&#8209;zfs&#8209;storageclass.chartVersion | string |  | Specify a specific chart version to use for this release |
openebs&#8209;zfs&#8209;storageclass.labels | object |  | Adds helmfile labels to this release |
openebs&#8209;zfs&#8209;storageclass.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
openebs&#8209;zfs&#8209;storageclass.values | (object *or* list of objects) |  | Pass values to the release helm chart |
targetNamespace | string | storage | Sets the cluster namespace in which the releases will be deployed |
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

