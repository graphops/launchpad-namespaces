// schema:type=namespace schema:namespace=celo
package LaunchpadNamespaces

#namespaces: {
	// Celo *Namespace*
	#celo: {
		meta: {
			name: "celo"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Celo mainnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			// suitable defaults for an alfajores archive node
			#alfajores: "alfajores"

			// suitable defaults for a baklava archive node
			#baklava: "baklava"

			#enum: ( #mainnet | #alfajores | #baklava )
		}

		// celo namespace features schema
		#features: {
			// Deploy proxyd
			#proxyd: "proxyd"

			#enum: ( #proxyd )
		}

		// celo scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1)
			// A beggining port for the range to use in P2P NodePorts
			startP2PPort?: int

			celo: {
				deployments?: int & >=1
			}
		}

		// celo namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is celo-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			features?: *defaults["\(defaults.flavor)"].features | [...#features.#enum]

			scaling?: *defaults["\(defaults.flavor)"].scaling | #scaling

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}

			// For overriding this release's values
			[string & "^(proxyd)-[0-9]+$"]?: #base.#releaseValues
		}

		// celo helmfile API
		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@celo/helmfile.yaml*"
			values?: #celo.#values | [...#celo.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {
				features: [#features.#proxyd]
				scaling: #scaling & {deployments: 1}
			}

			mainnet: {
				#common
				targetNamespace: "celo-mainnet"
			}

			alfajores: {
				#common
				targetNamespace: "celo-alfajores"
			}

			baklava: {
				#common
				targetNamespace: "celo-baklava"
			}
		}

		releases: {
			celo: {
				chart: {_repositories.graphops.charts.celo}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "execution"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				_template: {version: "0.1.2"}
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
			"launchpad.graphops.xyz/namespace":   "celo"
			"app.launchpad.graphops.xyz/type":    "blockchain"
			"app.launchpad.graphops.xyz/chain":   "celo"
			"app.launchpad.graphops.xyz/network": "{{ .Values.flavor }}"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "celo": _#namespaceTemplate & {_key: #namespaces.#celo}
