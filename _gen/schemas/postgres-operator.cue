package LaunchpadNamespaces

import (
	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
)

#namespaces: {
	#postgresOperator: {
		#meta: {
			name: "postgres operator"
			url:  "https://github.com/graphops/launchpad-namespaces/postgres-operator"
			description: """
				Extends your Kubernetes cluster with custom resources for easilly creating and managing Postgres databases
				"""
		}

		#releases: {
			postgresOperator: {
				name:  "postgres-operator"
				chart: charts.#repositories["postgres-operator-charts"].charts["postgres-operator"]
				_template: {version: "1.8.2"}
			}
		}

		// Postgres-Operator namespace values interface schema
		#values: #base.#values & {
			targetNamespace: *"postgres-operator" | string
			for key, release in #releases {
				"\(release.name)"?: {
					mergeValues?: bool
					values?:      #map | [...#map]
				}
			}
		}
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@postgres-operator/helmfile.yaml*"
			values?: #postgresOperator.#values | [...#postgresOperator.#values]
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "postgres-operator"
		}
	}
}

// instantiate an oject for internal usage
_namespaces: postgresOperator: {
	meta:     #namespaces.#postgresOperator.#meta
	releases: #namespaces.#postgresOperator.#releases
	values:   #namespaces.#postgresOperator.#values
	labels:   #namespaces.#postgresOperator.labels
}
