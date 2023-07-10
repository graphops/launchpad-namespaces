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
			// suitable defaults for a mainnet archive node
			#goerli: "goerli"

			#enum: ( #goerli )
		}

		// Graph namespace values schema
		#values: #base.#values & {
			// the default is graph-<flavor>
			targetNamespace?: *"graph-goerli" | string

			_templatedTargetNamespace: '( print "graph-" .Values.flavor )'

			flavor?: *"goerli" | #flavor.#enum

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

		// Graph helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@graph/helmfile.yaml*"
			values?: #graph.#values | [...#graph.#values]
		}

		releases: {
			"graph-node": {
				chart: {_repositories.graphops.charts["graph-node"]}
				_template: {version: "0.1.5"}
			}

			"graph-network-indexer": {
				chart: {_repositories.graphops.charts["graph-network-indexer"]}
				_template: {version: "0.1.2"}
			}

			"graph-toolbox": {
				chart: {_repositories.graphops.charts["graph-toolbox"]}
				_template: {version: "0.1.0"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "graph"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "graph": _#namespaceTemplate & {_key: #namespaces.#graph}
