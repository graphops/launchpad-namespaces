

# Monitoring Namespace

This *Namespace* adds software for log and metrics collection and visualization, as well as alarmistic.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Releases
- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)<br>
Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules
- [loki](https://github.com/grafana/loki/tree/main/production/helm/loki)<br>
Helm chart for Grafana Loki in microservices mode
- [node-problem-detector](https://github.com/deliveryhero/helm-charts/tree/master/stable/node-problem-detector)<br>
This chart installs a node-problem-detector daemonset. This tool aims to make various node problems visible to the upstream layers in cluster management stack.
- [promtail](https://github.com/grafana/helm-charts/tree/main/charts/promtail)<br>
Promtail is an agent which ships the contents of local logs to a Loki instance

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

Next, setup an `helmfile.yaml` file that makes use of the Monitoring *Namespace* by creating it with the following contents:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml?ref=monitoring-latest
    selectorsInherited: true
```

> **Note**
> On the path to the helmfile, you can use the query string's ref `(?ref=monitoring-latest)` to track one of the release streams: `stable` and `canary`, pin to a specific version or just track a particular major or minor semantic version.
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml?ref=monitoring-latest
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml?ref=monitoring-latest
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
  - path: git::https://github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml?ref=monitoring-latest
    selectorsInherited: true
    values:
      <monitoring values>
  - path: git::https://github.com/graphops/launchpad-namespaces.git@<other namespace>/helmfile.yaml?ref=<other namespace>-latest
    selectorsInherited: true
    values:
      <other values>
```

## Values

| Key | Type | Default | Description |
| :--- | :---: | :--- | :--- |
annotations | object |  | Add annotations to release resources on this namespace |
features | list of strings | [metrics, logs] | *enum of:&nbsp;&nbsp;(metrics \| logs)* |
kube&#8209;prometheus&#8209;stack | object |  |  |
kube&#8209;prometheus&#8209;stack.annotations | object |  | Add annotations to resources on this release |
kube&#8209;prometheus&#8209;stack.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
kube&#8209;prometheus&#8209;stack.chartVersion | string |  | Specify a specific chart version to use for this release |
kube&#8209;prometheus&#8209;stack.labels | object |  | Adds helmfile labels to this release |
kube&#8209;prometheus&#8209;stack.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
kube&#8209;prometheus&#8209;stack.resourceLabels | object |  | Adds labels to resources on this release |
kube&#8209;prometheus&#8209;stack.values | (object *or* list of objects) |  | Pass values to the release helm chart |
kubeVersion | string |  | Specifies the kubernetes API version, useful in helm templating environment |
labels | object |  | Adds helmfile labels to releases on this namespace |
loki | object |  |  |
loki.annotations | object |  | Add annotations to resources on this release |
loki.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
loki.chartVersion | string |  | Specify a specific chart version to use for this release |
loki.labels | object |  | Adds helmfile labels to this release |
loki.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
loki.resourceLabels | object |  | Adds labels to resources on this release |
loki.values | (object *or* list of objects) |  | Pass values to the release helm chart |
node&#8209;problem&#8209;detector | object |  |  |
node&#8209;problem&#8209;detector.annotations | object |  | Add annotations to resources on this release |
node&#8209;problem&#8209;detector.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
node&#8209;problem&#8209;detector.chartVersion | string |  | Specify a specific chart version to use for this release |
node&#8209;problem&#8209;detector.labels | object |  | Adds helmfile labels to this release |
node&#8209;problem&#8209;detector.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
node&#8209;problem&#8209;detector.resourceLabels | object |  | Adds labels to resources on this release |
node&#8209;problem&#8209;detector.values | (object *or* list of objects) |  | Pass values to the release helm chart |
promtail | object |  |  |
promtail.annotations | object |  | Add annotations to resources on this release |
promtail.chartUrl | string |  | Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main) |
promtail.chartVersion | string |  | Specify a specific chart version to use for this release |
promtail.labels | object |  | Adds helmfile labels to this release |
promtail.mergeValues | boolean | true | Merges passed values with namespace's defaults if true, overrides if false |
promtail.resourceLabels | object |  | Adds labels to resources on this release |
promtail.values | (object *or* list of objects) |  | Pass values to the release helm chart |
resourceLabels | object |  | Adds labels to release resources on this namespace |
targetNamespace | string | monitoring | Sets the cluster namespace in which the releases will be deployed |
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

