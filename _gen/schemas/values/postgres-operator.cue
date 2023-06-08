package launchpadNamespacesValues

_releases: {postgresOperator: ["postgres-operator"]}

#launchpadNamespacesValues: {
	// Postgres-Operator namespace values interface schema
	#postgresOperator: #launchpadNamespacesValues.#base & {
		targetNamespace: *"postgres-operator" | string
		for release in _releases.postgresOperator {
			"\(release)"?: {
				mergeValues?: bool
				values?:      #map | [...#map]
			}
		}
	}
}
