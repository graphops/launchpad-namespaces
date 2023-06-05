package storageValues

import common "graphops.xyz/launchpad:launchpadNamespaceValues"

_releases: ["openebs", "openebs-rawfile-localpv", "openebs-rawfile-storageclass", "openebs-zfs-localpv", "openebs-zfs-storageclass"]

// openebs: for the core openebs release
#featureOpenebs: "openebs"

// zfs: include the localpv-zfs release and storageclass
#featureZfs: "zfs"

// rawfile: include the localpv-rawfile release and storageclass
#featureRawfile: "rawfile"

#features: ( #featureOpenebs | #featureZfs | #featureRawfile )

#storageNamespaceValues: common.#launchpadNamespaceValues & {
	targetNamespace: *"storage" | string
	features?:       *[#featureOpenebs, #featureRawfile] | [...#features]
	for release in _releases {
		"\(release)"?: {
			mergeValues?: bool
			values?:      common.#map | [...common.#map]
		}
	}
}
