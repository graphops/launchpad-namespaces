// schema:type=namespace schema:namespace=polygon
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// eth-erigon namespace
	#polygon: {
		meta: {
			name: "polygon"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Polygon mainnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			#enum: ( #mainnet )
		}

		// eth-erigon namespace values schema
		#values: #base.#values & {
			// the default is eth-<flavor>
			targetNamespace?: *"polygon-mainnet" | string

			_templatedTargetNamespace: '( print "polygon-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

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
			path:    =~"*github.com/graphops/launchpad-namespaces.git@polygon/helmfile.yaml*"
			values?: #polygon.#values | [...#polygon.#values]
		}

		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				_template: {version: "0.6.1-canary.1"}
			}

			heimdall: {
				chart: {_repositories.graphops.charts.heimdall}
				_template: {version: "1.1.1"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.2.1-canary.2"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "polygon"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "polygon": _#namespaceTemplate & {_key: #namespaces.#polygon}
