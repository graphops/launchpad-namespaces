// schema:type=namespace schema:namespace=gnosis
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	// eth-erigon namespace
	#gnosis: {
		meta: {
			name: "gnosis"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				For deploying gnosis mainnet archive nodes
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			#enum: ( #mainnet )
		}

		// eth-erigon namespace values schema
		#values: #base.#values & {
			// the default is eth-<flavor>
			targetNamespace?: *"gnosis-mainnet" | string

			_templatedTargetNamespace: '( print "gnosis-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

			#releaseValues: {
				mergeValues?: *true | bool
				values?:      (#map) | [...#map]
			}

			for key, _ in releases {
				// release key for overloading values "\(release)"
				(key)?: #releaseValues
			}
		}

		// eth-erigon helmfile API
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
