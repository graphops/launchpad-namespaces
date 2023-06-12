package LaunchpadNamespaces

import (
	upstreamHelmfile "github.com/SchemaStore:helmfile"
)

#helmfile: {
	upstreamHelmfile.#helmfile
	helmfiles?: [...(
		string |
		#namespaces.#storage.#helmfiles |
		#namespaces.#sealedSecrets.#helmfiles |
		#namespaces.#postgresOperator.#helmfiles |
		#namespaces.#monitoring.#helmfiles |
		#namespaces.#ingress.#helmfiles |
		#namespaces.#ethereum.#helmfiles )]
}
