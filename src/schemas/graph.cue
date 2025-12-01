// schema:type=namespace schema:namespace=graph
package LaunchpadNamespaces

#namespaces: {
	// Graph *Namespace*
	#graph: {
		meta: {
			name: "graph"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides the necessary software to run a Graph Node and participate
				in the Graph Protocol Network
				"""
		}

		#flavor: {

			// suitable defaults for an arbitrum-one indexer
			#arbitrum_one: "arbitrum-one"

			// suitable defaults for an arbitrum-one indexer
			#arbitrum_sepolia: "arbitrum-sepolia"

			#enum: ( #arbitrum_one | #arbitrum_sepolia )
		}

		// ethereum namespace features schema
		#features: {
			// Deploy graph-node, part of the indexing stack
			#node: "node"

			// Deploy graph-network-indexer, service and agent parts of the indexing stack
			#network_indexer: "network-indexer"

			// Deploy graph-toolbox, a toolkit container with the CLI utilities
			#toolbox: "toolbox"

			// Deploy a database based on postgres-operator
			#database: "database"

			// Deploy Subgraph Radio
			#subgraph_radio: "subgraph-radio"

			#enum: ( #node | #network_indexer | #toolbox | #database | #subgraph_radio )
		}

		// Graph namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is graph-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			features?: *defaults["\(defaults.flavor)"].features | [...#features.#enum]

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// Graph helmfile API
		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@graph/helmfile.yaml*"
			values?: #graph.#values | [...#graph.#values]
		}

		defaults: {
			flavor: "arbitrum-one"

			#common: {
				features: [#features.#node, #features.#network_indexer, #features.#toolbox, #features.#database, #features.#subgraph_radio]
			}

			"arbitrum-one": {
				#common
				targetNamespace: "graph-arbitrum-one"
			}

			"arbitrum-sepolia": {
				#common
				targetNamespace: "graph-arbitrum-sepolia"
			}
		}

		releases: {
			"graph-node": {
				chart: {_repositories.graphops.charts["graph-node"]}
				feature: #features.#node
				_template: {version: "0.6.6"}
			}

			"graph-network-indexer": {
				chart: {_repositories.graphops.charts["graph-network-indexer"]}
				feature: #features.#network_indexer
				_template: {version: "0.6.0"}
			}

			"graph-toolbox": {
				chart: {_repositories.graphops.charts["graph-toolbox"]}
				feature: #features.#toolbox
				_template: {version: "0.1.3"}
			}

			"graph-operator-mnemonic": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				_template: {version: "0.2.0"}
			}

			"graph-database": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				feature: #features.#database
				_template: {version: "0.2.0"}
			}

			"subgraph-radio": {
				chart: {_repositories.graphops.charts["subgraph-radio"]}
				feature: #features.#subgraph_radio
				_template: {version: "0.2.18"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "graph"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "graph": _#namespaceTemplate & {_key: #namespaces.#graph}
