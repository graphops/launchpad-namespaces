package monitoringValues

import common "graphops.xyz/launchpad:launchpadNamespaceValues"

_releases: ["kube-prometheus-stack", "node-problem-detector", "loki", "promtail"]

// metrics: add kube-prometheus stack and node-problem-detector
#featureMetrics: "metrics"

// logs: add Loki and promtail for logging
#featureLogs: "logs"

#features: ( #featureMetrics | #featureLogs )

#monitoringNamespaceValues: common.#launchpadNamespaceValues & {
	targetNamespace: *"monitoring" | string
	features?:       *[#featureMetrics, #featureLogs] | [...#features]
	for release in _releases {
		"\(release)"?: {
			mergeValues?: bool
			values?:      common.#map | [...common.#map]
		}
	}
}
