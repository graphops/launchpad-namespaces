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
				This *Namespace* provides a suitable stack to operate Ethereum mainnet, göerli, holesky and sepolia archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			// suitable defaults for a holeśky ethereum testnet node
			#holesky: "holesky"

			// suitable defaults for a sepolia ethereum testnet node
			#sepolia: "sepolia"

			// suitable defaults for a hoodi ethereum testnet node
			#hoodi: "hoodi"

			#enum: ( #mainnet | #holesky | #sepolia | #hoodi )
		}

		// ethereum namespace features schema
		#features: {
			// Use nimbus as consensus layer
			#nimbus: "nimbus"

			// Use lighthouse as consensus layer
			#lighthouse: "lighthouse"

			// Deploy proxyd
			#proxyd: "proxyd"

			#enum: ( #nimbus | #lighthouse | #proxyd )
		}

		// ethereum scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1)
			// A beggining port for the range to use in P2P NodePorts
			startP2PPort?: int

			erigon: {
				deployments?: int & >=1
			}

			nimbus: {
				deployments?: int & >=1
			}

			lighthouse: {
				deployments?: int & >=1
			}
		}

		// ethereum namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is eth-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			features?: *defaults["\(defaults.flavor)"].features | [...#features.#enum]

			scaling?: *defaults["\(defaults.flavor)"].scaling | #scaling

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
			path: =~"*github.com/graphops/launchpad-namespaces.git@ethereum/helmfile.yaml*"
			values?: #ethereum.#values | [...#ethereum.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {
				features: [#features.#proxyd]
				scaling: #scaling & {deployments: 1}
			}

			mainnet: {
				#common
				targetNamespace: "eth-mainnet"
			}

			holesky: {
				#common
				targetNamespace: "eth-holesky"
			}

			sepolia: {
				#common
				targetNamespace: "eth-sepolia"
			}

			hoodi: {
				#common
				targetNamespace: "eth-hoodi"
			}
		}

		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "execution"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				_template: {version: "0.11.8"}
			}

			nimbus: {
				chart: {_repositories.graphops.charts.nimbus}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "consensus"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				feature: #features.#nimbus
				_template: {version: "0.6.7-canary.1"}
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
				_template: {version: "0.7.2"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				labels: {
					"app.launchpad.graphops.xyz/layer":     "proxy"
					"app.launchpad.graphops.xyz/release":   "{{ $release }}"
					"app.launchpad.graphops.xyz/component": "{{ $canonicalRelease }}"
				}
				feature: #features.#proxyd
				_template: {version: "0.6.14-canary.1"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace":   "ethereum"
			"app.launchpad.graphops.xyz/type":    "blockchain"
			"app.launchpad.graphops.xyz/chain":   "ethereum"
			"app.launchpad.graphops.xyz/network": "{{ .Values.flavor }}"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "ethereum": _#namespaceTemplate & {_key: #namespaces.#ethereum}
