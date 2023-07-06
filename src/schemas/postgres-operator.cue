// schema:type=namespace schema:namespace=postgres-operator
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	#postgresOperator: {
		meta: {
			name: "postgres-operator"
			url:  "https://github.com/graphops/launchpad-namespaces/postgres-operator"
			description: """
				Extends your Kubernetes cluster with custom resources for easilly creating and managing Postgres databases
				"""
		}

		// Postgres-Operator namespace values interface schema
		#values: #base.#values & {
			targetNamespace?: *"postgres-operator" | string

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
			path:    =~"*github.com/graphops/launchpad-namespaces.git@postgres-operator/helmfile.yaml*"
			values?: #values | [...#values]
		}

		releases: {
			"postgres-operator": {
				chart: {_repositories["postgres-operator-charts"].charts["postgres-operator"]}
				_template: {version: "1.8.2"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "postgres-operator"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "postgres-operator": _#namespaceTemplate & {_key: #namespaces.#postgresOperator}
