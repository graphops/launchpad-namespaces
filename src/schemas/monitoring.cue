// schema:type=namespace schema:namespace=monitoring
package LaunchpadNamespaces

#namespaces: {
	#monitoring: {
		meta: {
			name: "monitoring"
			url:  "https://github.com/graphops/launchpad-namespaces/monitoring"
			description: """
				This *Namespace* adds software for log and metrics collection and visualization, as well as alarmistic.
				"""
		}

		// Monitoring namespace features schema
		#features: {
			// metrics: add kube-prometheus stack and node-problem-detector
			#metrics: "metrics"

			// logs: add Loki and promtail for logging
			#logs: "logs"
			#enum: ( #metrics | #logs )
		}

		// Monitoring namespace values interface schema
		#values: #base.#values & {
			targetNamespace?: *"monitoring" | string

			features?: *[#features.#metrics, #features.#logs] | [...#features.#enum]

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

		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml*"
			values?: #monitoring.#values | [...#monitoring.#values]
		}

		releases: {
			"kube-prometheus-stack": {
				chart: {_repositories["prometheus-community"].charts["kube-prometheus-stack"]}
				feature: #features.#metrics
				_template: {
					version:                    "48.1.1"
					disableValidationOnInstall: true
				}
			}
			"node-problem-detector": {
				chart: {_repositories.deliveryhero.charts["node-problem-detector"]}
				feature: #features.#metrics
				_template: {version: "2.3.5"}
			}
			loki: {
				chart: {_repositories.grafana.charts["loki-distributed"]}
				feature: #features.#logs
				_template: {version: "0.69.16"}
			}
			promtail: {
				chart: {_repositories.grafana.charts.promtail}
				feature: #features.#logs
				_template: {version: "6.11.5"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "monitoring"
			"launchpad.graphops.xyz/layer":     "base"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "monitoring": _#namespaceTemplate & {_key: #namespaces.#monitoring}
