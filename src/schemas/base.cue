package LaunchpadNamespaces

import (
	upstreamHelmfile "github.com/SchemaStore:helmfile"
)

info: {
	description: """
		Launchpad Namespaces Schemas, by GraphOps (https://graphops.xyz)
		"""
}

// Launchpad Namespaces schemas, by GraphOps
#base: {
	// Base namespace values interface schema
	#values: {
		helmDefaults?: upstreamHelmfile.#helmDefaults
		// Specifies the kubernetes API version, useful in helm templating environment
		kubeVersion?: string
		// Sets the cluster namespace in which the releases will be deployed
		targetNamespace: string
		// Add annotations to releases on this namespace
		annotations?: {...} & #map
		// Adds labels to releases on this namespace
		labels?: {...} & #map
		...
	}

	#releaseValues: {
		// Merges passed values with namespace's defaults if true, overrides if false
		mergeValues?: *true | bool
		// Add annotations to resources on this release
		annotations?: {...} & #map
		// Adds helmfile labels to this release
		labels?: {...} & #map
		// Specify a specific chart version to use for this release
		chartVersion?: string
		// Override this release's chart URL (i.e: an absolute like /path/to/chart.tgz or /path/to/chart_dir. Or a remote like git::https://github.com/bitnami/charts.git@bitnami/apache?ref=main)
		chartUrl?: string
		// Pass values to the release helm chart
		values?: (#map) | [...#map]
	}

	#helmfiles: upstreamHelmfile

	#labels: {}
}

#map: {
	{[=~"[a-zA-Z\\d_-]+" & !~"^()$"]: ({
		...
	} | bool | string | [...] | null | int) & (null | bool | string | [...] | {
		...
	})
	}
	...
}

// template for instantiating namespace ojects for internal usage
_#namespaceTemplate: {
	_key:   _
	meta:   _key.meta
	values: _key.#values & {
		targetNamespace: _key.#values.targetNamespace
		if _key.#features != _|_ {features: [..._key.#features.#enum]}
		if _key.#flavor != _|_ {flavor: _key.#flavor.#enum}
		if _key.#scaling != _|_ {scaling: deployments: _key.#scaling.deployments}
		for rkey, _ in _key.releases {
			(rkey): {
				mergeValues: _key.#values.#releaseValues.mergeValues
				values:      _key.#values.#releaseValues.values
			}
		}
	}
	labels:   _key.labels
	releases: _key.releases
}
