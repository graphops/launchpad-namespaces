// schema:type=namespace schema:namespace=geo
package LaunchpadNamespaces

#namespaces: {
	#geo: {
		meta: {
			name: "geo"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate a Geo Browser Orbit L3 archive node.
				"""
		}

		#flavor: {
			// suitable defaults for an geo mainnet archive node
			#one: "one"

			#enum: ( #one )
		}

		// arbitrum namespace features schema
		#features: {
			// Deploy proxyd
			#proxyd: "proxyd"

			#geo: "geo"

			#enum: ( #proxyd | #geo )
		}

		// arbitrum scaling interface
		#scaling: {
			// number of independent stateful sets to deploy
			deployments: *1 | ( int & >=1 )

			"geo": {
				deployments?: int & >=1
			}
		}

		// arbitrum namespace values schema
		#values: #base.#values & {
			flavor?: *defaults.flavor | #flavor.#enum

			// the default is arbitrum-<flavor>
			targetNamespace?: *defaults["\(defaults.flavor)"].targetNamespace | string

			features?: *defaults["\(defaults.flavor)"].features | [...#features.#enum]

			scaling?: *defaults["\(defaults.flavor)"].scaling | #scaling

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}

			// For overriding this release's values
			[string & "^(geo|proxyd)-[0-9]+$"]?: #base.#releaseValues
		}

		// arbitrum helmfile API
		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@geo/helmfile.yaml*"
			values?: #geo.#values | [...#geo.#values]
		}

		defaults: {
			flavor: "one"

			#common: {
				scaling: #scaling & {deployments: 1}
			}

			one: {
				#common
				targetNamespace: "geo-one"
				features: [#features.#geo, #features.#proxyd]
			}
		}

		releases: {
			"geo": {
				chart: {_repositories.graphops.charts["arbitrum-nitro"]}
				labels: {
					"app.launchpad.graphops.xyz/layer":        "execution"
					"app.launchpad.graphops.xyz/release":      "{{ $release }}"
					"app.launchpad.graphops.xyz/component":    "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/scalingIndex": "{{ $deploymentIndex }}"
				}
				feature: #features.#geo
				_template: {version: "0.6.2-canary.2"}
			}

			"proxyd": {
				chart: {_repositories.graphops.charts.proxyd}
				labels: {
					"app.launchpad.graphops.xyz/layer":     "proxy"
					"app.launchpad.graphops.xyz/component": "{{ $canonicalRelease }}"
					"app.launchpad.graphops.xyz/release":   "{{ $release }}"
				}
				feature: #features.#proxyd
				_template: {version: "0.6.7"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace":   "geo"
			"app.launchpad.graphops.xyz/type":    "blockchain"
			"app.launchpad.graphops.xyz/chain":   "geo"
			"app.launchpad.graphops.xyz/network": "{{ .Values.flavor }}"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "geo": _#namespaceTemplate & {_key: #namespaces.#geo}
