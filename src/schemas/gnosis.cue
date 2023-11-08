// schema:type=namespace schema:namespace=gnosis
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// Gnosis *Namespace*
	#gnosis: {
		meta: {
			name: "gnosis"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Gnosis mainnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			#enum: ( #mainnet )
		}

		// gnosis namespace values schema
		#values: #base.#values & {
			flavor?: *"mainnet" | #flavor.#enum

			// the default is gnosis-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// gnosis helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@gnosis/helmfile.yaml*"
			values?: #gnosis.#values | [...#gnosis.#values]
		}

		defaults: {
			flavor: "mainnet"

			#common: {}

			mainnet: {
				#common
				targetNamespace: "gnosis-mainnet"
			}
		}

		releases: {
			nethermind: {
				chart: {_repositories.graphops.charts.nethermind}
				_template: {version: "0.4.2"}
			}

			nimbus: {
				chart: {_repositories.graphops.charts.nimbus}
				_template: {version: "0.5.4"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.4.0"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "gnosis"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "gnosis": _#namespaceTemplate & {_key: #namespaces.#gnosis}
