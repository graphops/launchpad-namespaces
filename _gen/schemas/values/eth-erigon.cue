package launchpadNamespacesValues

_releases: {
	ethErigon: ["erigon", "nimbus", "proxyd"]
}

#launchpadNamespacesValues: {#ethErigon: #launchpadNamespacesValues.#base & {
	#flavor: {
		// suitable defaults for a mainnet archive node
		#mainnet: "mainnet"

		// suitable defaults for a göerli archive node
		#goerli: "goerli"
		#enum:   ( #mainnet | #goerli )
	}

	// the default is eth-[flavor]
	targetNamespace: *"eth-mainnet" | string
	flavor?:         *"mainnet" | #flavor
	for release in _releases.ethErigon {
		"\(release)"?: {
			mergeValues?: bool
			values?:      #map | [...#map]
		}
	}
}
}
