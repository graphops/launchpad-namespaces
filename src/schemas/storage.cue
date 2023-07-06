// schema:type=namespace schema:namespace=storage
package LaunchpadNamespaces

// charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
#namespaces: {
	#storage: {
		meta: {
			name:    "storage"
			url:     "https://github.com/graphops/launchpad-namespaces/storage"
			version: "0.9.0"
			description: """
				...TODO...
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

		// Declaratively deploy [OpenEBS](https://openebs.io/) on your cluster
		#values: #base.#values & {
			targetNamespace?: *"storage" | string

			features?: *[#features.rawfile] | [...#features.#enum]

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
			path:    =~"*github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml*"
			values?: #storage.#values | [...#storage.#values]
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "storage"
			"launchpad.graphops.xyz/layer":     "base"
		}

		releases: {
			"openebs": {
				chart: {_repositories.openebs.charts.openebs}
				_template: {version: "3.6.0"}
			}
			"openebs-rawfile-localpv": {
				chart: {_repositories.graphops.charts["openebs-rawfile-localpv"]}
				feature: #features.#rawfile
				_template: {version: "0.8.1-canary.1"}
			}
			"openebs-rawfile-storageclass": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				feature: #features.#rawfile
				_template: {version: "0.2.0"}
			}
			"openebs-zfs-localpv": {
				chart: {_repositories["openebs-zfs-localpv"].charts["zfs-localpv"]}
				feature: #features.#zfs
				_template: {version: "2.2.0"}
			}
			"openebs-zfs-storageclass": {
				chart: {_repositories.graphops.charts["resource-injector"]}
				feature: #features.#zfs
				_template: {version: "0.2.0"}
			}
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "storage": _#namespaceTemplate & {_key: #namespaces.#storage}
