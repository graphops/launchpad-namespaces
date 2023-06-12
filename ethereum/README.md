

# Ethereum Namespace

eth-erigon namespace values schema

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)[![latest:stable](https://img.shields.io/badge/latest:stable-v1.0.0-blue)](https://github.com/graphops/launchpad-namespaces/releases)[![latest:canary](https://img.shields.io/badge/latest:canary-v1.0.1--pre.1-orange)](https://github.com/graphops/launchpad-namespaces/releases)

## Features

- Actively maintained by [GraphOps](https://graphops.xyz) [and contributors](https://github.com/graphops/launchpad-namespaces/graphs/contributors)

## Quickstart

These namespaces are meant to be used by [helmfile](https://github.com/helmfile/helmfile), so make sure to have helmfile available and kubeconfig context setup to a working cluster.

Create a `helmfile.yaml` file with a helmfiles entry pointing to this namespace, i.e.:

```yaml
helmfiles:
  - path: https://graphops.xyz/launchpad-namespaces.git@storage?ref=latest:stable
```

run:
> helmfile sync

## Values

| Key | Type | Default | Description |
| :--- | :---: | :--- | :--- |
annotations | object |  | Add annotations |
erigon | object |  |  |
erigon.mergeValues | boolean |  |  |
erigon.values | (object *or* list of objects) |  |  |
flavor | string |  |  |
labels | object |  | Adds labels |
nimbus | object |  |  |
nimbus.mergeValues | boolean |  |  |
nimbus.values | (object *or* list of objects) |  |  |
proxyd | object |  |  |
proxyd.mergeValues | boolean |  |  |
proxyd.values | (object *or* list of objects) |  |  |
targetNamespace | string | eth-mainnet | the default is eth-[flavor] |
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

