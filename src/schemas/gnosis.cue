// schema:type=namespace schema:namespace=gnosis
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// Gnosis *Namespace*
	#gnosis: {
		meta: {
			name: "gnosis"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Gnosis mainnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			// suitable defaults for a chiado testnet archive node
			#chiado: "chiado"

			#enum: ( #mainnet | #chiado )
		}

		// ethereum namespace features schema
		#features: {
			// Use lighthouse as consensus layer
			#lighthouse: "lighthouse"

			// Use erigon as execution layer
			#erigon: "erigon"

			// Use proxyd
			#proxyd: "proxyd"

			#enum: ( #lighthouse | #erigon | #proxyd )
		}

		// gnosis scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1 )
			// A beggining port for the range to use in P2P NodePorts
			startP2PPort?: int

			erigon: {
				deployments?: int & >=1
			}

			lighthouse: {
				deployments?: int & >=1
			}
		}

		// gnosis namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is gnosis-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			features?: *defaults["\(defaults.flavor)"].features | [...#features.#enum]

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// gnosis helmfile API
		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@gnosis/helmfile.yaml*"
			values?: #gnosis.#values | [...#gnosis.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {
				features: [#features.#erigon, #features.#lighthouse, #features.#proxyd]
				scaling: #scaling & {deployments: 1}
			}

			mainnet: {
				#common
				targetNamespace: "gnosis-mainnet"
			}

			chiado: {
				#common
				targetNamespace: "gnosis-chiado"
			}
		}

		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				feature: #features.#erigon
				labels: {
					"app.launchpad.graphops.xyz/layer":        "execution"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				_template: {version: "0.9.9-canary.1"}
			}

			lighthouse: {
				chart: {_repositories.graphops.charts.lighthouse}
				feature: #features.#lighthouse
				labels: {
					"app.launchpad.graphops.xyz/layer":        "consensus"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				_template: {version: "0.5.5-canary.1"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				feature: #features.#proxyd
				labels: {
					"app.launchpad.graphops.xyz/layer":     "proxy"
					"app.launchpad.graphops.xyz/release":   "{{ $release }}"
					"app.launchpad.graphops.xyz/component": "{{ $canonicalRelease }}"
				}
				_template: {version: "0.5.3-canary.2"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace":   "gnosis"
			"app.launchpad.graphops.xyz/type":    "blockchain"
			"app.launchpad.graphops.xyz/chain":   "gnosis"
			"app.launchpad.graphops.xyz/network": "{{ .Values.flavor }}"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "gnosis": _#namespaceTemplate & {_key: #namespaces.#gnosis}
