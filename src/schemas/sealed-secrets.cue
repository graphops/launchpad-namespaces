// schema:type=namespace schema:namespace=sealed-secrets
package LaunchpadNamespaces

#namespaces: {
	#sealedSecrets: {
		meta: {
			name: "sealed-secrets"
			url:  "https://github.com/graphops/launchpad-namespaces/sealed-secrets"
			description: """
				This *Namespace* provides a Kubernetes controller and tool for one-way encrypted Secrets
				"""
		}

		// Sealed-Secrets namespace values schema
		#values: #base.#values & {
			targetNamespace?: *"sealed-secrets" | string

			#releaseValues: {
				mergeValues?: *true | bool
				values?:      (#map) | [...#map]
			}

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #releaseValues
			}
		}

		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@sealed-secrets/helmfile.yaml*"
			values?: #values | [...#values]
		}

		releases: {
			"sealed-secrets": {
				chart: {_repositories["sealed-secrets"].charts["sealed-secrets"]}
				_template: {version: "2.11.0"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "sealed-secrets"
			"launchpad.graphops.xyz/layer":     "base"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "sealed-secrets": _#namespaceTemplate & {_key: #namespaces.#sealedSecrets}
