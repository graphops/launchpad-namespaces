package launchpadNamespacesValues

info: {
	description: """
		My long description
		test
		"""
}

_releases: {storage: ["openebs", "openebs-rawfile-localpv", "openebs-rawfile-storageclass", "openebs-zfs-localpv", "openebs-zfs-storageclass"]}

#launchpadNamespacesValues: {

	// Declaratively deploy [OpenEBS](https://openebs.io/) on your cluster
	#storage: #launchpadNamespacesValues.#base & {
		// storage namespace features schema
		#features: {
			// for the core openebs release
			#openebs: "openebs"

			// include the localpv-zfs release and storageclass
			#zfs: "zfs"

			// include the localpv-rawfile release and storageclass
			#rawfile: "rawfile"
			#enum:    ( feat.#openebs | feat.#zfs | feat.#rawfile )
		}
		let feat = #launchpadNamespacesValues.#storage.#features

		targetNamespace: *"storage" | string
		features?:       *[feat.#openebs, feat.#rawfile] | [...feat.#enum]
		for release in _releases.storage {
			// release key for overloading values "\(release)"
			"\(release)"?: {
				mergeValues?: *true | bool
				values?:      (#map) | [...#map]
			}
		}
	}
}
