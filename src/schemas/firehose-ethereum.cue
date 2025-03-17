// schema:type=namespace schema:namespace=firehose-ethereum
package LaunchpadNamespaces

#namespaces: {
	// Firehose-Ethereum *Namespace*
	#firehoseEthereum: {
		meta: {
			name: "firehose-ethereum"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides the necessary software to run the full constellation of Firehose services for Ethereum based chains
				"""
		}

		#flavor: {

			// suitable defaults for an ethereum mainnet indexer
			#eth_mainnet: "eth-mainnet"

			#eth_sepolia: "eth-sepolia"

			#arbitrum_one: "arbitrum-one"

			#arbitrum_sepolia: "arbitrum-sepolia"

			#polygon_mainnet: "polygon-mainnet"

			#enum: ( #eth_mainnet | #eth_sepolia | #arbitrum_one | #arbitrum_sepolia | #polygon_mainnet)
		}

		// ethereum namespace features schema
		#features: {
			//
			#consensus_nimbus: "consensus-nimbus"

			//
			#consensus_lighthouse: "consensus-lighthouse"

			#substreams: "substreams"

			#enum: ( #consensus_nimbus | #consensus_lighthouse | #substreams )
		}

		// firehose-ethereum scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1)
			// A beggining port for the range to use in P2P NodePorts
			startP2PPort?: int

			"firehose-ethereum": {
				deployments?: int & >=1
			}

			lighthouse: {
				deployments?: int & >=1
			}

			nimbus: {
				deployments?: int & >=1
			}
		}

		// Graph namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is graph-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			features?: *defaults["\(defaults.flavor)"].features | [...#features.#enum]

			scaling?: *defaults["\(defaults.flavor)"].scaling | #scaling

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// Graph helmfile API
		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@firehose-ethereum/helmfile.yaml*"
			values?: #firehoseEthereum.#values | [...#firehoseEthereum.#values]
		}

		defaults: {
			flavor: "eth-mainnet"

			#common: {
				scaling: #scaling & {deployments: 1}
			}

			"eth-mainnet": {
				#common
				features: [#features.#consensus_lighthouse]
				targetNamespace: "fh-eth-mainnet"
			}

			"eth-sepolia": {
				#common
				features: [#features.#consensus_lighthouse]
				targetNamespace: "fh-eth-sepolia"
			}

			"arbitrum-one": {
				#common
				features: []
				targetNamespace: "fh-arbitrum-one"
			}

			"arbitrum-sepolia": {
				#common
				features: []
				targetNamespace: "fh-arbitrum-sepolia"
			}

			"polygon-mainnet": {
				#common
				features: []
				targetNamespace: "fh-polygon-mainnet"
			}
		}

		releases: {
			"firehose-ethereum": {
				chart: {_repositories.graphops.charts["firehose-ethereum"]}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "execution"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				_template: {version: "0.1.0-canary.11"}
			}

			nimbus: {
				chart: {_repositories.graphops.charts.nimbus}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "consensus"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				feature: #features.#consensus_nimbus
				_template: {version: "0.6.2"}
			}

			lighthouse: {
				chart: {_repositories.graphops.charts.lighthouse}
				feature: #features.#consensus_lighthouse
				labels: {
					"app.launchpad.graphops.xyz/layer":        "consensus"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				_template: {version: "0.7.0"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "firehose-ethereum"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "firehose-ethereum": _#namespaceTemplate & {_key: #namespaces.#firehoseEthereum}
