// schema:type=namespace schema:namespace=arbitrum
package LaunchpadNamespaces

import (
)
//	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"

//	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"

//	// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// eth-erigon namespace
	#arbitrum: {
		meta: {
			name: "arbitrum"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				For deploying arbitrum mainnet archive nodes
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
			targetNamespace?: *"arbitrum-mainnet" | string

			_templatedTargetNamespace: '( print "arbitrum-" .Values.flavor )'

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
			path:    =~"*github.com/graphops/launchpad-namespaces.git@arbitrum/helmfile.yaml*"
			values?: #arbitrum.#values | [...#arbitrum.#values]
		}

		releases: {
			"arbitrum-nitro": {
				chart: {_repositories.graphops.charts["arbitrum-nitro"]}
				_template: {version: "0.1.1"}
			}

			"arbitrum-classic": {
				chart: {_repositories.graphops.charts["arbitrum-classic"]}
				_template: {version: "0.1.1"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.2.1-canary.2"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "arbitrum"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "arbitrum": _#namespaceTemplate & {_key: #namespaces.#arbitrum}
