// schema:type=namespace schema:namespace=polygon
package LaunchpadNamespaces

#namespaces: {
	// Polygon *Namespace*
	#polygon: {
		meta: {
			name: "polygon"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Polygon mainnet and mumbai testnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			// suitable defaults for a mumbai testnet archive node
			#mumbai: "mumbai"

			// suitable defaults for an amoy testnet archive node
			#amoy: "amoy"

			#enum: ( #mainnet | #mumbai | #amoy )
		}

		// polygon namespace features schema
		#features: {
			// Deploy proxyd
			#proxyd: "proxyd"

			#enum: ( #proxyd )
		}

		// polygon scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1)
			// A beggining port for the range to use in P2P NodePorts
			startP2PPort?: int

			erigon: {
				deployments?: int & >=1
			}

			heimdall: {
				deployments?: int & >=1
			}
		}

		// polygon namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is polygon-<flavor>
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

		// polygon helmfile API
		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@polygon/helmfile.yaml*"
			values?: #polygon.#values | [...#polygon.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {
				features: [#features.#proxyd]
				scaling: #scaling & {deployments: 1}
			}

			mainnet: {
				#common
				targetNamespace: "polygon-mainnet"
			}

			mumbai: {
				#common
				targetNamespace: "polygon-mumbai"
			}

			amoy: {
				#common
				targetNamespace: "polygon-amoy"
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
				_template: {version: "0.9.9-canary.1"}
			}

			heimdall: {
				chart: {_repositories.graphops.charts.heimdall}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "consensus"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				_template: {version: "1.1.5-canary.4"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				labels: {
					"app.launchpad.graphops.xyz/layer":     "proxy"
					"app.launchpad.graphops.xyz/release":   "{{ $release }}"
					"app.launchpad.graphops.xyz/component": "{{ $canonicalRelease }}"
				}
				feature: #features.#proxyd
				_template: {version: "0.5.3-canary.2"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace":   "polygon"
			"app.launchpad.graphops.xyz/type":    "blockchain"
			"app.launchpad.graphops.xyz/chain":   "polygon"
			"app.launchpad.graphops.xyz/network": "{{ .Values.flavor }}"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "polygon": _#namespaceTemplate & {_key: #namespaces.#polygon}
