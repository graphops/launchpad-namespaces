package LaunchpadNamespaces

import (
	upstreamHelmfile "github.com/SchemaStore:helmfile"
	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
)

info: {
	description: """
		TODO
		"""
}

// Launchpad Namespaces schemas, by GraphOps
#base: {
	// Base namespace values interface schema
	#values: {
		helmDefaults?: upstreamHelmfile.#helmDefaults
		// Sets the cluster namespace in which the releases will be deployed
		targetNamespace: string
		// Add annotations
		annotations?: {...} & #map
		// Adds labels
		labels?: {...} & #map
		...
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

// instantiate a repositories oject for internal usage
_repositories: {charts.#repositories}
