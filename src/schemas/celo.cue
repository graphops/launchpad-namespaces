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
			// the default is celo-<flavor>
			targetNamespace?: *"celo-mainnet" | string

			_templatedTargetNamespace: '( print "celo-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

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

		releases: {
			celo: {
				chart: {_repositories.graphops.charts.celo}
				_template: {version: "0.1.1-canary.2"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.3.4-canary.7"}
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
