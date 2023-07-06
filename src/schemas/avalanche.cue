// schema:type=namespace schema:namespace=avalanche
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// eth-erigon namespace
	#avalanche: {
		meta: {
			name: "avalanche"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				For deploying avalanche mainnet archive nodes
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
			targetNamespace?: *"avalanche-mainnet" | string

			_templatedTargetNamespace: '( print "avalanche-" .Values.flavor )'

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
			path:    =~"*github.com/graphops/launchpad-namespaces.git@avalanche/helmfile.yaml*"
			values?: #avalanche.#values | [...#avalanche.#values]
		}

		releases: {
			avalanche: {
				chart: {_repositories.graphops.charts.avalanche}
				_template: {version: "0.1.0"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.1.8"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "avalanche"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "avalanche": _#namespaceTemplate & {_key: #namespaces.#avalanche}
