// schema:type=namespace schema:namespace=scroll
package LaunchpadNamespaces

#namespaces: {
	// Scroll *Namespace*
	#scroll: {
		meta: {
			name: "scroll"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Scroll mainnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			#enum: ( #mainnet )
		}

		// scroll namespace features schema
		#features: {
			// Deploy proxyd
			#proxyd: "proxyd"

			#enum: ( #proxyd )
		}

		// scroll scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1)
			// A beggining port for the range to use in P2P NodePorts
			startP2PPort?: int

			scroll: {
				deployments?: int & >=1
			}
		}

		// scroll namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is scroll-<flavor>
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

		// scroll helmfile API
		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@scroll/helmfile.yaml*"
			values?: #scroll.#values | [...#scroll.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {
				features: [#features.#proxyd]
				scaling: #scaling & {deployments: 1}
			}

			mainnet: {
				#common
				targetNamespace: "scroll-mainnet"
			}
		}

		releases: {
			scroll: {
				chart: {_repositories.graphops.charts.scroll}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "execution"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				_template: {version: "0.0.1"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				labels: {
					"app.launchpad.graphops.xyz/layer":     "proxy"
					"app.launchpad.graphops.xyz/release":   "{{ $release }}"
					"app.launchpad.graphops.xyz/component": "{{ $canonicalRelease }}"
				}
				feature: #features.#proxyd
				_template: {version: "0.6.6"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace":   "scroll"
			"app.launchpad.graphops.xyz/type":    "blockchain"
			"app.launchpad.graphops.xyz/chain":   "scroll"
			"app.launchpad.graphops.xyz/network": "{{ .Values.flavor }}"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "scroll": _#namespaceTemplate & {_key: #namespaces.#scroll}
