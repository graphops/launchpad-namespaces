// schema:type=namespace schema:namespace=monitoring
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	#monitoring: {
		meta: {
			name: "monitoring"
			url:  "https://github.com/graphops/launchpad-namespaces/monitoring"
			description: """
				Adds software for log and metrics collection and visualization, as well as alarmistic.
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

			for key, _ in releases {
				// release key for overloading values "\(release)"
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
					version:                    "41.3.2"
					disableValidationOnInstall: true
				}
			}
			"node-problem-detector": {
				chart: {_repositories.deliveryhero.charts["node-problem-detector"]}
				feature: #features.#metrics
				_template: {version: "2.2.2"}
			}
			loki: {
				chart: {_repositories.grafana.charts["loki-distributed"]}
				feature: #features.#logs
				_template: {version: "0.55.4"}
			}
			promtail: {
				chart: {_repositories.grafana.charts.promtail}
				feature: #features.#logs
				_template: {version: "6.2.3"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "monitoring"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "monitoring": _#namespaceTemplate & {_key: #namespaces.#monitoring}
