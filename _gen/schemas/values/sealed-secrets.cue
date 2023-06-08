package sealedSecretsValues

import common "graphops.xyz/launchpad:launchpadNamespaceValues"

_releases: ["sealed-secrets"]

#sealedSecretsNamespaceValues: common.#launchpadNamespaceValues & {
	targetNamespace: *"sealed-secrets" | string
	features:        null
	flavor:          null
	for release in _releases {
		"\(release)"?: {
			mergeValues?: bool
			values?:      common.#map | [...common.#map]
		}
	}
}
