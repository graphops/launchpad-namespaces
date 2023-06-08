package ethErigonValues

import common "graphops.xyz/launchpad:launchpadNamespaceValues"

_releases: ["erigon", "nimbus", "proxyd"]

// suitable defaults for a mainnet archive node
#flavorMainnet: "mainnet"

// suitable defaults for a göerli archive node
#flavorGoerli: "goerli"

#flavor: ( #flavorMainnet | #flavorGoerli )

#ethErigonNamespaceValues: common.#launchpadNamespaceValues & {
	// the default is eth-[flavor]
	targetNamespace: *"eth-mainnet" | string
	flavor?:         *"mainnet" | #flavor
	for release in _releases {
		"\(release)"?: {
			mergeValues?: bool
			values?:      common.#map | [...common.#map]
		}
	}
}
