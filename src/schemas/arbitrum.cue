// schema:type=namespace schema:namespace=arbitrum
package LaunchpadNamespaces

#namespaces: {
	// Arbitrum *Namespace* values interface
	#arbitrum: {
		meta: {
			name: "arbitrum"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Arbitrum mainnet archive nodes.
				"""
		}

		// Suitable defaults for a mainnet archive node
		#flavor: {
			#mainnet: "mainnet"

			#enum: ( #mainnet )
		}

		// Arbitrum
		#values: #base.#values & {
			// Choose among default values best suited for different scenarios
			// currently supports "mainnet" only
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is arbitrum-(flavor)
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// Arbitrum helmfile schema
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@arbitrum/helmfile.yaml*"
			values?: #arbitrum.#values | [...#arbitrum.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {}

			mainnet: {
				#common
				targetNamespace: "arbitrum-mainnet"
			}
		}

		releases: {
			"arbitrum-nitro": {
				chart: {_repositories.graphops.charts["arbitrum-nitro"]}
				_template: {version: "0.1.4"}
			}

			"arbitrum-classic": {
				chart: {_repositories.graphops.charts["arbitrum-classic"]}
				_template: {version: "0.1.4"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.4.0"}
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
