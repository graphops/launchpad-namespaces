package launchpadHelmfile

import (
	baseHelmfile "github.com/SchemaStore:helmfile"
	"graphops.xyz/launchpad/namespaces/storage:storageValues"
	"graphops.xyz/launchpad/namespaces/eth-erigon:ethErigonValues"
	"graphops.xyz/launchpad/namespaces/sealed-secrets:sealedSecretsValues"
	"graphops.xyz/launchpad/namespaces/postgres-operator:postgresOperatorValues"
	"graphops.xyz/launchpad/namespaces/ingress:ingressValues"
	"graphops.xyz/launchpad/namespaces/monitoring:monitoringValues"
)

#launchpadHelmfile: ( baseHelmfile.#helmfile |
	{
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml*"
		values: {storageValues.#storageNamespaceValues} | [...{storageValues.#storageNamespaceValues}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@eth-erigon/helmfile.yaml*"
		values: {ethErigonValues.#ethErigonNamespaceValues} | [...{ethErigonValues.#ethErigonNamespaceValues}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@sealed-secrets/helmfile.yaml*"
		values: {sealedSecretsValues.#sealedSecretsNamespaceValues} | [...{sealedSecretsValues.#sealedSecretsNamespaceValues}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@postgres-operator/helmfile.yaml*"
		values: {postgresOperatorValues.#postgresOperatorNamespaceValues} | [...{postgresOperatorValues.#postgresOperatorNamespaceValues}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@ingress/helmfile.yaml*"
		values: {ingressValues.#ingressNamespaceValues} | [...{ingressValues.#ingressNamespaceValues}]
	} | {
		baseHelmfile.#helmfile
		path:   =~"*github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml*"
		values: {monitoringValues.#monitoringNamespaceValues} | [...{monitoringValues.#monitoringNamespaceValues}]
	})

helmfiles?: [...(string | #launchpadHelmfile)]
