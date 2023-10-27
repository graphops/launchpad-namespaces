// schema:type=namespace schema:namespace=arbitrum
package LaunchpadNamespaces

#namespaces: {
	// Arbitrum *Namespace* values interface
	#arbitrum: {
		meta: {
			name: "arbitrum"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Arbitrum onde and görli archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for an arbitrum-one archive node
			#one: "one"

			// suitable defaults for an arbitrum-görli archive node
			#goerli: "goerli"

			#enum: ( #one | #goerli )
		}

		// arbitrum namespace features schema
		#features: {
			// Deploy proxyd
			#proxyd: "proxyd"

			#arbitrum_classic: "arbitrum_classic"

			#enum: ( #proxyd | #arbitrum_classic )
		}

		// arbitrum scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | int
			// A beggining port for the range to use in P2P NodePorts
			startP2PPort?: int
		}

		// arbitrum namespace values schema
		#values: #base.#values & {
			// the default is arbitrum-<flavor>
			targetNamespace?: *"arbitrum-one" | string

			_templatedTargetNamespace: '( print "arbitrum-" .Values.flavor )'

			features?: *[#features.#proxyd , #features.#arbitrum_classic] | [...#features.#enum]

			flavor?: *"one" | #flavor.#enum

			scaling?: #scaling

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}

			// For overriding this release's values
			[string & "^(arbitrum-classic|arbitrum-nitro|proxyd)-[0-9]+$"]?: #base.#releaseValues
		}

		// arbitrum helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@arbitrum/helmfile.yaml*"
			values?: #arbitrum.#values | [...#arbitrum.#values]
		}

		releases: {
			"arbitrum-nitro": {
				chart: {_repositories.graphops.charts["arbitrum-nitro"]}
				_template: {version: "0.1.3"}
				_scale: true
			}

			"arbitrum-classic": {
				chart: {_repositories.graphops.charts["arbitrum-classic"]}
				feature: #features.#arbitrum_classic
				_template: {version: "0.1.3"}
				_scale: true
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				feature: #features.#proxyd
				_template: {version: "0.3.4-canary.4"}
				_scale: false
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
