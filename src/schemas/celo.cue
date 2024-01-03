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

			#enum: ( #mainnet )
		}

		// celo namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is celo-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// celo helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@celo/helmfile.yaml*"
			values?: #celo.#values | [...#celo.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {}

			mainnet: {
				#common
				targetNamespace: "celo-mainnet"
			}
		}

		releases: {
			celo: {
				chart: {_repositories.graphops.charts.celo}
				_template: {version: "0.1.1-canary.2"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.4.2-canary.1"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "celo"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "celo": _#namespaceTemplate & {_key: #namespaces.#celo}
