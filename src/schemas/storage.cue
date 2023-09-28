// schema:type=namespace schema:namespace=storage
package LaunchpadNamespaces

#namespaces: {
	#storage: {
		meta: {
			name:    "storage"
			url:     "https://github.com/graphops/launchpad-namespaces/storage"
			version: "0.9.0"
			description: """
				This *Namespace* uses [OpenEBS](https://openebs.io) to provide a software defined storage layer
				suitable for stateful workloads that require low-latency access to the storage.
				"""
		}

		// storage namespace features schema
		#features: {
			// include the localpv-zfs release and storageclass
			#zfs: "zfs"

			// include the localpv-rawfile release and storageclass
			#rawfile: "rawfile"

			#enum: ( #zfs | #rawfile )
		}

		#values: #base.#values & {
			targetNamespace?: *"storage" | string

			features?: *[#features.#rawfile] | [...#features.#enum]

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #base.#releaseValues
			}
		}
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml*"
			values?: #storage.#values | [...#storage.#values]
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "storage"
			"launchpad.graphops.xyz/layer":     "base"
		}

		resourceLabels: {
			#base.#resourceLabels
		}

		releases: {
			"openebs": {
				chart: {_repositories.openebs.charts.openebs}
				_template: {version: "3.9.0"}
			}
			"openebs-rawfile-localpv": {
				chart: {_repositories.graphops.charts["openebs-rawfile-localpv"]}
				feature: #features.#rawfile
				_template: {version: "0.8.2"}
			}
			"openebs-rawfile-storageclass": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				feature: #features.#rawfile
				_template: {version: "0.2.0"}
			}
			"openebs-zfs-localpv": {
				chart: {_repositories["openebs-zfs-localpv"].charts["zfs-localpv"]}
				feature: #features.#zfs
				_template: {version: "2.3.1"}
			}
			"openebs-zfs-storageclass": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				feature: #features.#zfs
				_template: {version: "0.2.0"}
			}
			"openebs-zfs-snapclass": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				feature: #features.#zfs
				_template: {version: "0.2.0"}
			}
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "storage": _#namespaceTemplate & {_key: #namespaces.#storage}
