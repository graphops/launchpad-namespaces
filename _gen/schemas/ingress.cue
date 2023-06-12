package LaunchpadNamespaces

import (
	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
)

// define this namespace schema

#namespaces: {
	#ingress: {
		#meta: {
			name: "ingress"
			url:  "https://github.com/graphops/launchpad-namespaces/ingress"
			description: """
				Adds ingress support and certificate management on kubernetes
				"""
		}

		#releases: {
			ingressNginx: {
				name:  "ingress-nginx"
				chart: charts.#repositories["ingress-nginx"].charts["ingress-nginx"]
				//				feature: #features.ingress
				_template: {version: "4.3.0"}
			}
			certManager: {
				name:  "cert-manager"
				chart: charts.#repositories.jetstack.charts["cert-manager"]
				//				feature: #features.certManager
				_template: {version: "v1.10.0"}
			}
			certManagerResources: {
				name:  "cert-manager-resources"
				chart: charts.#repositories.graphops.charts["resource-injector"]
				//				feature: #features.certManager
				_template: {version: "0.2.0"}
			}
		}

		#features: {
			// cert-manager: include cert-manager
			certManager: "cert-manager"

			// ingress: for the ingress-nginx release
			ingress: "ingress"

			// ingress features enum
			#enum: ( ingress | certManager )
		}
		#values: #base.#values & {
			targetNamespace: *"ingress" | string
			features?:       *[#features.ingress, #features.certManager] | [...#features.#enum]
			for key, release in #releases {
				"\(release.name)"?: {
					mergeValues?: bool
					values?:      #map | [...#map]
				}
			}
		}

		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@ingress/helmfile.yaml*"
			values?: #ingress.#values | [...#ingress.#values]
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "ingress"
		}
	}
}

// instantiate an oject for internal usage
_namespaces: ingress: {
	meta:     #namespaces.#ingress.#meta
	releases: #namespaces.#ingress.#releases
	features: #namespaces.#ingress.#features
	values:   #namespaces.#ingress.#values
	labels:   #namespaces.#ingress.labels
}
