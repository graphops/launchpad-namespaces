// schema:type=namespace schema:namespace=avalanche
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// Avalanche *Namespace*
	#avalanche: {
		meta: {
			name: "avalanche"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Avalanche mainnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			#enum: ( #mainnet )
		}

		// avalanche namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is avalanche-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// avalanche helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@avalanche/helmfile.yaml*"
			values?: #avalanche.#values | [...#avalanche.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {}

			mainnet: {
				#common
				targetNamespace: "avalanche-mainnet"
			}
		}

		releases: {
			avalanche: {
				chart: {_repositories.graphops.charts.avalanche}
				_template: {version: "0.1.3-canary.4"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.4.0"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "avalanche"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "avalanche": _#namespaceTemplate & {_key: #namespaces.#avalanche}
