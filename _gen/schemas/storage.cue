// schema:type=namespace schema:namespace=storage
package LaunchpadNamespaces

import (
	charts "graphops.xyz/launchpad/namespaces:LaunchpadCharts"
)

#namespaces: {
	#storage: {
		#meta: {
			name: "storage"
			url:  "https://github.com/graphops/launchpad-namespaces/storage"
			description: """
				...TODO...
				"""
		}

		// storage namespace features schema
		#features: {
			// include the localpv-zfs release and storageclass
			zfs: "zfs"

			// include the localpv-rawfile release and storageclass
			rawfile: "rawfile"

			#enum: ( zfs | rawfile )
		}

		#releases: {
			openebs: {
				name:  "openebs"
				chart: charts.#repositories.openebs.charts.openebs
				_template: {version: "3.6.0"}
			}
			openebsRawfileLocalpv: {
				name:    "openebs-rawfile-localpv"
				chart:   charts.#repositories.graphops.charts["openebs-rawfile-localpv"]
				feature: #features.rawfile
				_template: {version: "0.8.0"}
			}
			openebsRawfileStorageclass: {
				name:    "openebs-rawfile-storageclass"
				chart:   charts.#repositories.graphops.charts["resource-injector"]
				feature: #features.rawfile
				_template: {version: "0.2.0"}
			}
			openebsZfsLocalpv: {
				name:    "openebs-zfs-localpv"
				chart:   charts.#repositories["openebs-zfs-localpv"].charts["zfs-localpv"]
				feature: #features.zfs
				_template: {version: "2.1.0"}
			}
			openebsZfsStorageclass: {
				name:    "openebs-zfs-storageclass"
				chart:   charts.#repositories.graphops.charts["resource-injector"]
				feature: #features.zfs
				_template: {version: "0.2.0"}
			}
		}

		// Declaratively deploy [OpenEBS](https://openebs.io/) on your cluster
		#values: #base.#values & {
			targetNamespace?: *"storage" | string
			features?:        *[#features.rawfile] | [...#features.#enum]
			for key, release in #releases {
				// release key for overloading values "\(release)"
				"\(release.name)"?: {
					mergeValues?: *true | bool
					values?:      (#map) | [...#map]
				}
			}
		}
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@storage/helmfile.yaml*"
			values?: #storage.#values | [...#storage.#values]
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "storage"
		}
	}
}

// instantiate an oject for internal usage
_namespaces: storage: {
	meta:     #namespaces.#storage.#meta
	releases: #namespaces.#storage.#releases
	features: #namespaces.#storage.#features
	values:   #namespaces.#storage.#values & {
		targetNamespace: #namespaces.#storage.#values.targetNamespace
		features: [...#namespaces.#storage.#features.#enum]
	}
	labels: #namespaces.#storage.labels
}
