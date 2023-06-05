package launchpadNamespaceValues

import (
	helmfile "github.com/SchemaStore:helmfile"
)

// base schema for launchpad namespace values
#launchpadNamespaceValues: {
	helmDefaults?: helmfile.#helmDefaults
	// Sets the cluster namespace in which the releases will be deployed
	targetNamespace: string
	// Add annotations
	annotations?: #map
	// Adds labels
	labels?: #map
	...
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
