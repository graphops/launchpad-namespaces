// schema:type=namespace schema:namespace=polygon
package LaunchpadNamespaces

#namespaces: {
	// Polygon *Namespace*
	#polygon: {
		meta: {
			name: "polygon"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Polygon mainnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			#enum: ( #mainnet )
		}

		// polygon namespace values schema
		#values: #base.#values & {
			// the default is polygon-<flavor>
			targetNamespace?: *"polygon-mainnet" | string

			_templatedTargetNamespace: '( print "polygon-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		// polygon helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@polygon/helmfile.yaml*"
			values?: #polygon.#values | [...#polygon.#values]
		}

		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				_template: {version: "0.8.5-canary.9"}
			}

			heimdall: {
				chart: {_repositories.graphops.charts.heimdall}
				_template: {version: "1.1.4-canary.1"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.3.4-canary.7"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "polygon"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "polygon": _#namespaceTemplate & {_key: #namespaces.#polygon}
