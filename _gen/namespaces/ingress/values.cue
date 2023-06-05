package ingressValues

import common "graphops.xyz/launchpad:launchpadNamespaceValues"

_releases: ["ingress-nginx", "cert-manager", "cert-manager-resources"]

// ingress: for the ingress-nginx release
#featureIngress: "ingress"

// cert-manager: include cert-manager
#featureCertManager: "cert-manager"

#features: ( #featureIngress | #featureCertManager )

#ingressNamespaceValues: common.#launchpadNamespaceValues & {
	targetNamespace: *"ingress" | string
	features?:       *[#featureIngress, #featureCertManager] | [...#features]
	for release in _releases {
		"\(release)"?: {
			mergeValues?: bool
			values?:      common.#map | [...common.#map]
		}
	}
}
