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
			targetNamespace?: *defaults.#common.targetNamespace | string

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@sealed-secrets/helmfile.yaml*"
			values?: #values | [...#values]
		}

		defaults: {
			#common: {
				targetNamespace: "sealed-secrets"
			}
		}

		releases: {
			"sealed-secrets": {
				chart: {_repositories["sealed-secrets"].charts["sealed-secrets"]}
				_template: {version: "2.17.7"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "sealed-secrets"
			"launchpad.graphops.xyz/layer":     "base"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "sealed-secrets": _#namespaceTemplate & {_key: #namespaces.#sealedSecrets}
