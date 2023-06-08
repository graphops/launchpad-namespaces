package launchpadNamespacesValues

import (
	helmfile "github.com/SchemaStore:helmfile"
)

info: {
	description: """
		My long description
		test
		"""
}

// Launchpad Namespaces schemas, by GraphOps
#launchpadNamespacesValues: {
	// Base namespace values interface schema
	#base: {
		helmDefaults?: helmfile.#helmDefaults
		// Sets the cluster namespace in which the releases will be deployed
		targetNamespace: string
		// Add annotations
		annotations?: {...} & #map
		// Adds labels
		labels?: {...} & #map
		...
	}
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
