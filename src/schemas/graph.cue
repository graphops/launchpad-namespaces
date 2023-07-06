// schema:type=namespace schema:namespace=graph
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// eth-erigon namespace
	#graph: {
		meta: {
			name: "graph"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """

				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#goerli: "goerli"

			#enum: ( #goerli )
		}

		// eth-erigon namespace values schema
		#values: #base.#values & {
			// the default is eth-<flavor>
			targetNamespace?: *"graph-goerli" | string

			_templatedTargetNamespace: '( print "graph-" .Values.flavor )'

			flavor?: *"goerli" | #flavor.#enum

			#releaseValues: {
				mergeValues?: *true | bool
				values?:      (#map) | [...#map]
			}

			for key, _ in releases {
				// release key for overloading values "\(release)"
				(key)?: #releaseValues
			}
		}

		// eth-erigon helmfile API
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
