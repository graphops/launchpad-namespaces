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

		// ethereum scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | int
			// A beggining port for the range to use in P2P NodePorts
			startP2PPort?: int
		}

		// ethereum namespace values schema
		#values: #base.#values & {
			// the default is eth-<flavor>
			targetNamespace?: *"eth-mainnet" | string

			features?: *[#features.#nimbus, #features.#proxyd] | [...#features.#enum]

			_templatedTargetNamespace: '( print "eth-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

			scaling?: #scaling

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}

			// For overriding this release's values
			[string & "^(erigon|nimbus|proxyd)-[0-9]+$"]?: #base.#releaseValues
		}

		// ethereum helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@ethereum/helmfile.yaml*"
			values?: #ethereum.#values | [...#ethereum.#values]
		}

		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				labels: {
					"database.launchpad.graphops.xyz/chain":   "ethereum"
					"database.launchpad.graphops.xyz/network": "{{ .Values.flavor }}"
					"database.launchpad.graphops.xyz/layer":   "execution"
				}
				_template: {version: "0.8.2"}
				_scale: true
			}

			nimbus: {
				chart: {_repositories.graphops.charts.nimbus}
				labels: {
					"database.launchpad.graphops.xyz/chain": "ethereum"
					"database.launchpad.graphops.xyz/layer": "consensus"
				}
				feature: #features.#nimbus
				_template: {version: "0.5.2"}
				_scale: true
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				labels: {
					"database.launchpad.graphops.xyz/chain": "ethereum"
					"database.launchpad.graphops.xyz/layer": "proxy"
				}
				feature: #features.#proxyd
				_template: {version: "0.3.4-canary.4"}
				_scale: false
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
