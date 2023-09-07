// schema:type=namespace schema:namespace=postgres-operator
package LaunchpadNamespaces

#namespaces: {
	#postgresOperator: {
		meta: {
			name: "postgres-operator"
			url:  "https://github.com/graphops/launchpad-namespaces/postgres-operator"
			description: """
				This *Namespace* extends your Kubernetes cluster with custom resources for easilly creating and managing Postgres databases
				"""
		}

		// Postgres-Operator namespace values interface schema
		#values: #base.#values & {
			targetNamespace?: *"postgres-operator" | string

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
			path:    =~"*github.com/graphops/launchpad-namespaces.git@postgres-operator/helmfile.yaml*"
			values?: #values | [...#values]
		}

		releases: {
			"postgres-operator": {
				chart: {_repositories["postgres-operator-charts"].charts["postgres-operator"]}
				_template: {
					version: "1.10.1"
					// so that it can be installed in the absence of the CRDs
					disableValidationOnInstall: true
				}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "postgres-operator"
			"launchpad.graphops.xyz/layer":     "base"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "postgres-operator": _#namespaceTemplate & {_key: #namespaces.#postgresOperator}
