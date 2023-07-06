// schema:type=namespace schema:namespace=ethereum
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// eth-erigon namespace
	#ethereum: {
		meta: {
			name: "ethereum"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				For deploying ethereum mainnet and göerli archive nodes
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			// suitable defaults for a göerli archive node
			#goerli: "goerli"
			#enum:   ( #mainnet | #goerli )
		}

		// eth-erigon namespace values schema
		#values: #base.#values & {
			// the default is eth-<flavor>
			targetNamespace?: *"eth-mainnet" | string

			_templatedTargetNamespace: '( print "eth-" .Values.flavor )'

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
			path:    =~"*github.com/graphops/launchpad-namespaces.git@eth-erigon/helmfile.yaml*"
			values?: #ethereum.#values | [...#ethereum.#values]
		}

		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				_template: {version: "0.6.1-canary.1"}
			}

			nimbus: {
				chart: {_repositories.graphops.charts.nimbus}
				_template: {version: "0.3.1-canary.1"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.2.1-canary.2"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "ethereum"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "ethereum": _#namespaceTemplate & {_key: #namespaces.#ethereum}
