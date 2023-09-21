// schema:type=namespace schema:namespace=ethereum
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// Ethereum *Namespace*
	#ethereum: {
		meta: {
			name: "ethereum"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Ethereum mainnet and göerli archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			// suitable defaults for a göerli archive node
			#goerli: "goerli"
			#enum:   ( #mainnet | #goerli )
		}

		// ethereum namespace features schema
		#features: {
			// Use nimbus as consensus layer
			#nimbus: "nimbus"

			// Deploy proxyd
			#proxyd: "proxyd"

			#enum: ( #nimbus | #proxyd )
		}

		// ethereum namespace values schema
		#values: #base.#values & {
			// the default is eth-<flavor>
			targetNamespace?: *"eth-mainnet" | string

			features?: *[#features.#nimbus, #features.#proxyd] | [...#features.#enum]

			_templatedTargetNamespace: '( print "eth-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

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

		// ethereum helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@ethereum/helmfile.yaml*"
			values?: #ethereum.#values | [...#ethereum.#values]
		}

		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				_template: {version: "0.8.2"}
			}

			nimbus: {
				chart: {_repositories.graphops.charts.nimbus}
				feature: #features.#nimbus
				_template: {version: "0.5.2"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				feature: #features.#proxyd
				_template: {version: "0.3.4-canary.4"}
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
