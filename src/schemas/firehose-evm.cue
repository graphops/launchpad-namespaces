// schema:type=namespace schema:namespace=firehose-evm
package LaunchpadNamespaces

#namespaces: {
	// Firehose-EVM *Namespace*
	#firehoseEvm: {
		meta: {
			name: "firehose-evm"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides the necessary software to run the full constellation of Firehose services for EVM based chains
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

			#enum: ( #consensus_nimbus | #consensus_lighthouse )
		}

		// Graph namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is graph-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			features?: *defaults["\(defaults.flavor)"].features | [...#features.#enum]

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// Graph helmfile API
		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@firehose-evm/helmfile.yaml*"
			values?: #firehoseEvm.#values | [...#firehoseEvm.#values]
		}

		defaults: {
			flavor: "eth-mainnet"

			#common: {
				features: [#features.#consensus_lighthouse]
			}

			"eth-mainnet": {
				#common
				targetNamespace: "fh-eth-mainnet"
			}

			"eth-sepolia": {
				#common
				targetNamespace: "fh-eth-sepolia"
			}

			"arbitrum-one": {
				#common
				targetNamespace: "fh-arbitrum-one"
			}

			"arbitrum-sepolia": {
				#common
				targetNamespace: "fh-arbitrum-sepolia"
			}

			"polygon-mainnet": {
				#common
				targetNamespace: "fh-polygon-mainnet"
			}
		}

		releases: {
			"firehose-evm": {
				chart: {_repositories.graphops.charts["graph-node"]}
				_template: {version: "0.5.3"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "firehose-evm"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "firehose-evm": _#namespaceTemplate & {_key: #namespaces.#firehoseEvm}
