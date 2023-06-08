package launchpadNamespacesValues

_releases: {
	monitoring: ["kube-prometheus-stack", "node-problem-detector", "loki", "promtail"]
}

#launchpadNamespacesValues: {
	// Monitoring namespace values interface schema
	#monitoring: #launchpadNamespacesValues.#base & {

		// Monitoring namespace features schema
		#features: {
			// metrics: add kube-prometheus stack and node-problem-detector
			#metrics: "metrics"

			// logs: add Loki and promtail for logging
			#logs: "logs"
			#enum: ( #metrics | #logs )
		}

		targetNamespace: *"monitoring" | string
		features?:       *[#features.#metrics, #features.#logs] | [...#features.#enum]
		for release in _releases.monitoring {
			"\(release)"?: {
				mergeValues?: bool
				values?:      #map | [...#map]
			}
		}
	}
}
