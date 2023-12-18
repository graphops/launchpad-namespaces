// schema:type=namespace schema:namespace=arbitrum-one
package LaunchpadNamespaces

#namespaces: {
	#arbitrumOne: {
		meta: {
			name: "arbitrum-one"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Arbitrum One mainnet, görli and sepolia archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for an arbitrum-one-mainnet archive node
			#mainnet: "mainnet"

			// suitable defaults for an arbitrum-one-sepolia archive node
			#sepolia: "sepolia"

			#enum: ( #mainnet | #sepolia )
		}

		// arbitrum-one namespace features schema
		#features: {
			// Deploy proxyd
			#proxyd: "proxyd"

			#arbitrum_classic: "arbitrum_classic"

			#arbitrum_nitro: "arbitrum_nitro"

			#enum: ( #proxyd | #arbitrum_classic | #arbitrum_nitro )
		}

		// arbitrum-one scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1 )
		}

		// arbitrum-one namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is arbitrum-one-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			features?: *defaults["\(defaults.flavor)"].features | [...#features.#enum]

			scaling?: *defaults["\(defaults.flavor)"].scaling | #scaling

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}

			// For overriding this release's values
			[string & "^(arbitrum-classic|arbitrum-nitro|proxyd)-[0-9]+$"]?: #base.#releaseValues
		}

		// arbitrum-one helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@arbitrum-one/helmfile.yaml*"
			values?: #arbitrumOne.#values | [...#arbitrumOne.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {
				scaling: #scaling & {deployments: 1}
			}

			mainnet: {
				#common
				targetNamespace: "arbitrum-one-mainnet"
				features: [#features.#proxyd, #features.#arbitrum_classic, #features.#arbitrum_nitro]
			}

			sepolia: {
				#common
				targetNamespace: "arbitrum-one-sepolia"
				features: [#features.#proxyd, #features.#arbitrum_nitro]
			}
		}

		releases: {
			"arbitrum-nitro": {
				chart: {_repositories.graphops.charts["arbitrum-nitro"]}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "execution"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				feature: #features.#arbitrum_nitro
				_template: {version: "0.2.0"}
				_scale: true
			}

			"arbitrum-classic": {
				chart: {_repositories.graphops.charts["arbitrum-classic"]}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "execution"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				feature: #features.#arbitrum_classic
				_template: {version: "0.2.0"}
				_scale: true
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				labels: {
					"app.launchpad.graphops.xyz/layer":     "proxy"
					"app.launchpad.graphops.xyz/component": "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/release":   "{{ $release }}"
				}
				feature: #features.#proxyd
				_template: {version: "0.4.1-canary.3"}
				_scale: false
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace":   "arbitrum-one"
			"app.launchpad.graphops.xyz/type":    "blockchain"
			"app.launchpad.graphops.xyz/chain":   "arbitrum-one"
			"app.launchpad.graphops.xyz/network": "{{ .Values.flavor }}"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "arbitrum-one": _#namespaceTemplate & {_key: #namespaces.#arbitrumOne}
