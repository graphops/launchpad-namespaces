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
			// the default is avalanche-<flavor>
			targetNamespace?: *"avalanche-mainnet" | string

			_templatedTargetNamespace: '( print "avalanche-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

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

		releases: {
			avalanche: {
				chart: {_repositories.graphops.charts.avalanche}
				_template: {version: "0.1.0"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.1.8"}
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
