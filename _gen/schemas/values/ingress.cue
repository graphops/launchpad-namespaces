package launchpadNamespacesValues

_releases: {
	ingress: ["ingress-nginx", "cert-manager", "cert-manager-resources"]
}

#launchpadNamespacesValues: {#ingress: #launchpadNamespacesValues.#base & {
	#features: {
		// cert-manager: include cert-manager
		#certManager: "cert-manager"

		// ingress: for the ingress-nginx release
		#ingress: "ingress"

		// ingress features enum
		#enum: ( #ingress | #certManager )
	}

	targetNamespace: *"ingress" | string
	features?:       *[#features.#ingress, #features.#certManager] | [...#features.#ingress]
	for release in _releases.ingress {
		"\(release)"?: {
			mergeValues?: bool
			values?:      #map | [...#map]
		}
	}
}

}
