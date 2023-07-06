

# Sealed-Secrets Namespace

Sealed-Secrets namespace values schema

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)[![latest:stable](https://img.shields.io/badge/latest:stable-v1.0.0-blue)](https://github.com/graphops/launchpad-namespaces/releases)[![latest:canary](https://img.shields.io/badge/latest:canary-v1.0.1--pre.1-orange)](https://github.com/graphops/launchpad-namespaces/releases)

## Features

- Actively maintained by [![GraphOps](https://avatars.githubusercontent.com/u/85314764?s=12&v=4) *GraphOps*](https://graphops.xyz) [and contributors](https://github.com/graphops/launchpad-namespaces/graphs/contributors)
- Common values interfaces across all namespaces
- Flexible and adaptable, allowing defaults to be overriden
- Two release channels: `main` and `canary`
- A large selection of Namespaces (listed below)

## Quickstart

> **Note**
> [~~*Launchpad Starter*~~ support for *Namespaces* will be available soon](https://github.com/graphops/launchpad-starter) is a great way to make use of *Namespaces* and worth checking out

To use *Namespaces* you will require both a [*Kubernetes*](https://kubernetes.io) cluster and [*Helmfile*](https://github.com/helmfile/helmfile).
As such:
- Make sure your *Kubernetes* *Cluster* is in order and your environment has the *kubeconfig* context adequately setup
- Install *helmfile*, upstream guidance available here: [*Helmfile* Installation](https://github.com/helmfile/helmfile#installation)

Next, setup an `helmfile.yaml` file that makes use of the sealed-secrets *Namespace* by creating it with the following contents:
```yaml
helmfiles:
  - path: git::https://github.com/graphops/launchpad-namespaces.git@sealed-secrets/helmfile.yaml?ref=sealed-secrets:latest
    selectorsInherited: true
```

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

Answer yes and hopefully the installation will conclude successfully.

### a shot exaplantion on selecting the ?ref

add more quick examples:
### pass some values

### use features

### use values

### mention how to install multiple namespaces

## Values

| Key | Type | Default | Description |
| :--- | :---: | :--- | :--- |
annotations | object |  | Add annotations |
labels | object |  | Adds labels |
sealed&#8209;secrets | object |  |  |
sealed&#8209;secrets.mergeValues | boolean | true |  |
sealed&#8209;secrets.values | (object *or* list of objects) |  |  |
targetNamespace | string | sealed-secrets | Sets the cluster namespace in which the releases will be deployed |
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

