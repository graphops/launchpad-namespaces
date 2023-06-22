// schema:type=namespace schema:namespace=ethereum
package LaunchpadNamespaces

import (
	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
)

#namespaces: {
	// eth-erigon namespace
	#ethereum: {
		#meta: {
			name: "ethereum"
			url:  "https://github.com/graphops/launchpad-namespaces/eth-erigon"
			description: """
				For deploying ethereum mainnet and göerli archive nodes
				"""
		}

		#releases: {
			erigon: {
				name:  "erigon"
				chart: charts.#repositories.graphops.charts.erigon
				_template: {version: "0.6.0"}
			}

			nimbus: {
				name:  "nimbus"
				chart: charts.#repositories.graphops.charts.nimbus
				_template: {version: "0.3.0"}
			}

			proxyd: {
				name:  "proxyd"
				chart: charts.#repositories.graphops.charts.proxyd
				_template: {version: "0.1.8"}
			}
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			mainnet: "mainnet"

			// suitable defaults for a göerli archive node
			goerli: "goerli"
			#enum:  ( mainnet | goerli )
		}

		// eth-erigon namespace values schema
		#values: #base.#values & {
			// the default is eth-<flavor>
			targetNamespace:           *"eth-mainnet" | string
			_templatedTargetNamespace: '( print "eth-" .Values.flavor )'
			flavor:                    *"mainnet" | #flavor.#enum
			for key, release in #releases {
				"\(release.name)"?: {
					mergeValues?: bool
					values?:      #map | [...#map]
				}
			}
		}

		// eth-erigon helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@eth-erigon/helmfile.yaml*"
			values?: #ethereum.#values | [...#ethereum.#values]
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "ethereum"
		}
	}
}

// instantiate an oject for internal usage
_namespaces: ethereum: {
	meta:     #namespaces.#ethereum.#meta
	releases: #namespaces.#ethereum.#releases
	flavor:   #namespaces.#ethereum.#flavor
	values:   #namespaces.#ethereum.#values & {
		targetNamespace: #namespaces.#ethereum.#values.targetNamespace
		flavor:          #namespaces.#ethereum.#flavor.#enum
	}
	labels: #namespaces.#ethereum.labels
}
