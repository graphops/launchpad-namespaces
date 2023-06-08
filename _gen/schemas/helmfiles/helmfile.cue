package launchpadNamespacesHelmfiles

import (
	baseHelmfile "github.com/SchemaStore:helmfile"
	values "graphops.xyz/launchpad:launchpadNamespacesValues"
)

#launchpadNamespacesHelmfiles: ( baseHelmfile.#helmfile |
	{
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml*"
		values: {values.#launchpadNamespacesValues.#storage} | [...values.#launchpadNamespacesValues.#storage]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@eth-erigon/helmfile.yaml*"
		values: {values.#launchpadNamespacesValues.#ethErigon} | [...{values.#launchpadNamespacesValues.ethErigon}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@sealed-secrets/helmfile.yaml*"
		values: {values.#launchpadNamespacesValues.#sealedSecrets} | [...{values.#launchpadNamespacesValues.sealedSecrets}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@postgres-operator/helmfile.yaml*"
		values: {values.#launchpadNamespacesValues.#postgresOperator} | [...{values.#launchpadNamespacesValues.#postgresOperator}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@ingress/helmfile.yaml*"
		values: {values.#launchpadNamespacesValues.#ingress} | [...{values.#launchpadNamespacesValues.#ingress}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml*"
		values: {values.#launchpadNamespacesValues.#monitoring} | [...{values.#launchpadNamespacesValues.#monitoring}]
	})

helmfiles?: [...(string | #launchpadHelmfile)]
