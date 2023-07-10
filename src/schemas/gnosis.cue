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
			// the default is gnosis-<flavor>
			targetNamespace?: *"gnosis-mainnet" | string

			_templatedTargetNamespace: '( print "gnosis-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

			#releaseValues: {
				mergeValues?: *true | bool
				values?:      (#map) | [...#map]
			}

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #releaseValues
			}
		}

		// gnosis helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@gnosis/helmfile.yaml*"
			values?: #gnosis.#values | [...#gnosis.#values]
		}

		releases: {
			nethermind: {
				chart: {_repositories.graphops.charts.nethermind}
				_template: {version: "0.2.0"}
			}

			nimbus: {
				chart: {_repositories.graphops.charts.nimbus}
				_template: {version: "0.3.0"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.1.8"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "gnosis"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "gnosis": _#namespaceTemplate & {_key: #namespaces.#gnosis}
