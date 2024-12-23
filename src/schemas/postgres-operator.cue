// schema:type=namespace schema:namespace=postgres-operator
package LaunchpadNamespaces

#namespaces: {
	#postgresOperator: {
		meta: {
			name: "postgres-operator"
			url:  "https://github.com/graphops/launchpad-namespaces/postgres-operator"
			description: """
				This *Namespace* extends your Kubernetes cluster with custom resources for easily creating and managing Postgres databases
				"""
		}

		// Postgres-Operator namespace values interface schema
		#values: #base.#values & {
			targetNamespace?: *defaults.#common.targetNamespace | string

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@postgres-operator/helmfile.yaml*"
			values?: #values | [...#values]
		}

		defaults: {
			#common: {
				targetNamespace: "postgres-operator"
			}
		}

		releases: {
			"postgres-operator": {
				chart: {_repositories["postgres-operator-charts"].charts["postgres-operator"]}
				_template: {
					version: "1.14.0"
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

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "postgres-operator": _#namespaceTemplate & {_key: #namespaces.#postgresOperator}
