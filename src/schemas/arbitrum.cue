// schema:type=namespace schema:namespace=arbitrum
package LaunchpadNamespaces

#namespaces: {
	// Arbitrum *Namespace* values interface
	#arbitrum: {
		meta: {
			name: "arbitrum"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Arbitrum one, görli and sepolia archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for an arbitrum-one archive node
			#one: "one"

			// suitable defaults for an arbitrum-görli archive node
			#goerli: "goerli"

			// suitable defaults for an arbitrum-sepolia archive node
			#sepolia: "sepolia"

			#enum: ( #one | #goerli | #sepolia )
		}

		// arbitrum namespace features schema
		#features: {
			// Deploy proxyd
			#proxyd: "proxyd"

			#arbitrum_classic: "arbitrum_classic"

			#arbitrum_nitro: "arbitrum_nitro"

			#enum: ( #proxyd | #arbitrum_classic | #arbitrum_nitro )
		}

		// arbitrum scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1 )
		}

		// arbitrum namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is arbitrum-<flavor>
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

		// arbitrum helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@arbitrum/helmfile.yaml*"
			values?: #arbitrum.#values | [...#arbitrum.#values]
		}

		defaults: {
			flavor: "one"

			#common: {
				scaling: #scaling & {deployments: 1}
			}

			one: {
				#common
				targetNamespace: "arbitrum-one"
				features: [#features.#proxyd, #features.#arbitrum_classic, #features.#arbitrum_nitro]
			}

			goerli: {
				#common
				targetNamespace: "arbitrum-goerli"
				features: [#features.#proxyd, #features.#arbitrum_nitro]
			}

			sepolia: {
				#common
				targetNamespace: "arbitrum-sepolia"
				features: [#features.#proxyd, #features.#arbitrum_nitro]
			}
		}

		releases: {
			"arbitrum-nitro": {
				chart: {_repositories.graphops.charts["arbitrum-nitro"]}
				feature: #features.#arbitrum_nitro
				_template: {version: "0.2.0"}
				_scale: true
			}

			"arbitrum-classic": {
				chart: {_repositories.graphops.charts["arbitrum-classic"]}
				feature: #features.#arbitrum_classic
				_template: {version: "0.2.0"}
				_scale: true
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				feature: #features.#proxyd
				_template: {version: "0.4.0"}
				_scale: false
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "arbitrum"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "arbitrum": _#namespaceTemplate & {_key: #namespaces.#arbitrum}
