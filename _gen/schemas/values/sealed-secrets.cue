package launchpadNamespaceValues

_releases: {sealedSecrets: ["sealed-secrets"]}

#launchpadNamespacesValues: {
	// Sealed-Secrets namespace values schema
	#sealedSecrets: #launchpadNamespacesValues.#base & {
		targetNamespace: *"sealed-secrets" | string
		for release in _releases.sealedSecrets {
			"\(release)"?: {
				mergeValues?: bool
				values?:      #map | [...#map]
			}
		}
	}
}
