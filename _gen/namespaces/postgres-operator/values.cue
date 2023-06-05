package postgresOperatorValues

import common "graphops.xyz/launchpad:launchpadNamespaceValues"

_releases: ["postgres-operator"]

#postgresOperatorNamespaceValues: common.#launchpadNamespaceValues & {
	targetNamespace: *"postgres-operator" | string
	for release in _releases {
		"\(release)"?: {
			mergeValues?: bool
			values?:      common.#map | [...common.#map]
		}
	}
}
