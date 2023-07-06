// schema:type=namespace schema:namespace=sealed-secrets
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	#sealedSecrets: {
		meta: {
			name: "sealed-secrets"
			url:  "https://github.com/graphops/launchpad-namespaces/sealed-secrets"
			description: """
				...TODO...
				"""
		}

		// Sealed-Secrets namespace values schema
		#values: #base.#values & {
			targetNamespace?: *"sealed-secrets" | string

			#releaseValues: {
				mergeValues?: *true | bool
				values?:      (#map) | [...#map]
			}

			for key, _ in releases {
				// release key for overloading values "\(release)"
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
				_template: {version: "2.6.9"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "sealed-secrets"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "sealed-secrets": _#namespaceTemplate & {_key: #namespaces.#sealedSecrets}
