// schema:type=namespace schema:namespace=ingress
package LaunchpadNamespaces

// define this namespace schema

#namespaces: {
	#ingress: {
		meta: {
			name: "ingress"
			url:  "https://github.com/graphops/launchpad-namespaces/ingress"
			description: """
				This *Namespace* adds ingress support and certificate management on kubernetes
				"""
		}

		#features: {
			// cert-manager: include cert-manager
			#certManager: "cert-manager"

			// ingress: for the ingress-nginx release
			#ingress: "ingress"

			// ingress features enum
			#enum: ( #ingress | #certManager )
		}

		#values: #base.#values & {
			targetNamespace?: *defaults.#common.targetNamespace | string

			features?: *defaults.#common.features | [...#features.#enum]

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}

		}

		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@ingress/helmfile.yaml*"
			values?: #ingress.#values | [...#ingress.#values]
		}

		defaults: {
			#common: {
				targetNamespace: "ingress"
				features: [#features.#ingress, #features.#certManager]
			}
		}

		releases: {
			"ingress-nginx": {
				chart: {_repositories["ingress-nginx"].charts["ingress-nginx"]}
				feature: #features.#ingress
				_template: {version: "4.11.0"}
			}
			"cert-manager": {
				chart: {_repositories.jetstack.charts["cert-manager"]}
				feature: #features.#certManager
				_template: {
					version: "v1.15.1"
					// so that it can be installed in the absence of the CRDs
					disableValidationOnInstall: true
				}
			}
			"cert-manager-resources": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				feature: #features.#certManager
				_template: {version: "0.2.0"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "ingress"
			"launchpad.graphops.xyz/layer":     "base"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "ingress": _#namespaceTemplate & {_key: #namespaces.#ingress}
