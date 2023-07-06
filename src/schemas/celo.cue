// schema:type=namespace schema:namespace=celo
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// eth-erigon namespace
	#celo: {
		meta: {
			name: "celo"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				For deploying celo mainnet archive nodes
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
			targetNamespace?: *"celo-mainnet" | string

			_templatedTargetNamespace: '( print "celo-" .Values.flavor )'

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
			path:    =~"*github.com/graphops/launchpad-namespaces.git@celo/helmfile.yaml*"
			values?: #celo.#values | [...#celo.#values]
		}

		releases: {
			celo: {
				chart: {_repositories.graphops.charts.celo}
				_template: {version: "0.1.0"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.1.8"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "celo"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "celo": _#namespaceTemplate & {_key: #namespaces.#celo}
