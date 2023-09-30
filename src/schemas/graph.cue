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
			// suitable defaults for a goerli indexer
			#goerli: "goerli"

			// suitable defaults for an arbitrum-goerli indexer
			#arbitrum_goerli: "arbitrum-goerli"

			// suitable defaults for a mainnet indexer
			#mainnet: "mainnet"

			#enum: ( #goerli | #mainnet | #arbitrum_goerli )
		}

		// Graph namespace values schema
		#values: #base.#values & {
			// the default is graph-<flavor>
			targetNamespace?: *"graph-mainnet" | string

			_templatedTargetNamespace: '( print "graph-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// Graph helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@graph/helmfile.yaml*"
			values?: #graph.#values | [...#graph.#values]
		}

		releases: {
			"graph-node": {
				chart: {_repositories.graphops.charts["graph-node"]}
				_template: {version: "0.3.0"}
			}

			"graph-network-indexer": {
				chart: {_repositories.graphops.charts["graph-network-indexer"]}
				_template: {version: "0.2.2-canary.4"}
			}

			"graph-toolbox": {
				chart: {_repositories.graphops.charts["graph-toolbox"]}
				_template: {version: "0.1.0"}
			}

			"graph-operator-mnemonic": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				_template: {version: "0.2.0"}
			}

			"graph-database": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				_template: {version: "0.2.0"}
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
