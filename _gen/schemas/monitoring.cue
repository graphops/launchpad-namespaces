// schema:type=namespace schema:namespace=monitoring
package LaunchpadNamespaces

import (
	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
)

#namespaces: {
	#monitoring: {
		#meta: {
			name: "monitoring"
			url:  "https://github.com/graphops/launchpad-namespaces/monitoring"
			description: """
				Adds software for log and metrics collection and visualization, as well as alarmistic.
				"""
		}

		#releases: {
			kubePrometheusStack: {
				name:    "kube-prometheus-stack"
				chart:   charts.#repositories["prometheus-community"].charts["kube-prometheus-stack"]
				feature: #features.metrics
				_template: {version: "41.3.2"}
			}
			nodeProblemDetector: {
				name:    "node-problem-detector"
				chart:   charts.#repositories.deliveryhero.charts["node-problem-detector"]
				feature: #features.metrics
				_template: {version: "2.2.2"}
			}
			loki: {
				name:    "loki"
				chart:   charts.#repositories.grafana.charts["loki-distributed"]
				feature: #features.logs
				_template: {version: "0.55.4"}
			}
			promtail: {
				name:    "promtail"
				chart:   charts.#repositories.grafana.charts.promtail
				feature: #features.logs
				_template: {version: "6.2.3"}
			}
		}

		// Monitoring namespace features schema
		#features: {
			// metrics: add kube-prometheus stack and node-problem-detector
			metrics: "metrics"

			// logs: add Loki and promtail for logging
			logs:  "logs"
			#enum: ( metrics | logs )
		}

		// Monitoring namespace values interface schema
		#values: #base.#values & {
			targetNamespace: *"monitoring" | string
			features?:       *[#features.metrics, #features.logs] | [...#features.#enum]
			for key, release in #releases {
				"\(release.name)"?: {
					mergeValues?: bool
					values?:      #map | [...#map]
				}
			}
		}

		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@monitoring/helmfile.yaml*"
			values?: #monitoring.#values | [...#monitoring.#values]
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "monitoring"
		}
	}
}

// instantiate an oject for internal usage
_namespaces: monitoring: {
	meta:     #namespaces.#monitoring.#meta
	releases: #namespaces.#monitoring.#releases
	features: #namespaces.#monitoring.#features
	values:   #namespaces.#monitoring.#values & {
		targetNamespace: #namespaces.#monitoring.#values.targetNamespace
		features: [...#namespaces.#monitoring.#values.#features.#enum]
	}
	labels: #namespaces.#monitoring.labels
}
