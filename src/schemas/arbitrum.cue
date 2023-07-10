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
			// the default is arbitrum-(flavor)
			targetNamespace?: *"arbitrum-mainnet" | string

			_templatedTargetNamespace: '( print "arbitrum-" .Values.flavor )'

			// Choose among default values best suited for different scenarios
			// currently supports "mainnet" only
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

		// Arbitrum helmfile schema
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@arbitrum/helmfile.yaml*"
			values?: #arbitrum.#values | [...#arbitrum.#values]
		}

		releases: {
			"arbitrum-nitro": {
				chart: {_repositories.graphops.charts["arbitrum-nitro"]}
				_template: {version: "0.1.1"}
			}

			"arbitrum-classic": {
				chart: {_repositories.graphops.charts["arbitrum-classic"]}
				_template: {version: "0.1.1"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.2.1"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "arbitrum"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "arbitrum": _#namespaceTemplate & {_key: #namespaces.#arbitrum}
