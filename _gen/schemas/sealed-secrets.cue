// schema:type=namespace schema:namespace=sealed-secrets
package LaunchpadNamespaces

import (
	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
)

#namespaces: {
	#sealedSecrets: {
		#meta: {
			name: "sealed secrets"
			url:  "https://github.com/graphops/launchpad-namespaces/sealed-secrets"
			description: """
				...TODO...
				"""
		}

		#releases: {
			sealedSecrets: {
				name:  "sealed-secrets"
				chart: charts.#repositories["sealed-secrets"].charts["sealed-secrets"]
				_template: {version: "2.6.9"}
			}
		}

		// Sealed-Secrets namespace values schema
		#values: #base.#values & {
			targetNamespace: *"sealed-secrets" | string
			for key, release in #releases {
				"\(release.name)"?: {
					mergeValues?: bool
					values?:      #map | [...#map]
				}
			}
		}

		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@sealed-secrets/helmfile.yaml*"
			values?: #sealedSecrets.#values | [...#sealedSecrets.#values]
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "sealed-secrets"
		}
	}
}

// instantiate an oject for internal usage
_namespaces: sealedSecrets: {
	meta:     #namespaces.#sealedSecrets.#meta
	releases: #namespaces.#sealedSecrets.#releases
	values:   #namespaces.#sealedSecrets.#values & {
		targetNamespace: #namespaces.#sealedSecrets.#values.targetNamespace
	}
	labels: #namespaces.#sealedSecrets.labels
}
