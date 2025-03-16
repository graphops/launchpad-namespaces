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
			targetNamespace?: *defaults.#common.targetNamespace | string

			features?: *defaults.#common.features | [...#features.#enum]

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}

		#helmfiles: #base.#helmfiles & {
			path: =~"*github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml*"
			values?: #monitoring.#values | [...#monitoring.#values]
		}

		defaults: {
			#common: {
				targetNamespace: "monitoring"
				features: [#features.#metrics, #features.#logs]
			}
		}

		releases: {
			"kube-prometheus-stack": {
				chart: {_repositories["prometheus-community"].charts["kube-prometheus-stack"]}
				feature: #features.#metrics
				_template: {
					version:                    "70.0.1"
					disableValidationOnInstall: true
				}
			}
			"node-problem-detector": {
				chart: {_repositories.deliveryhero.charts["node-problem-detector"]}
				feature: #features.#metrics
				_template: {version: "2.3.14"}
			}
			loki: {
				chart: {_repositories.grafana.charts["loki-distributed"]}
				feature: #features.#logs
				_template: {version: "0.80.1"}
			}
			promtail: {
				chart: {_repositories.grafana.charts.promtail}
				feature: #features.#logs
				_template: {version: "6.16.6"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "monitoring"
			"launchpad.graphops.xyz/layer":     "base"
		}

		resourceLabels: {
			#base.#resourceLabels
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "monitoring": _#namespaceTemplate & {_key: #namespaces.#monitoring}
