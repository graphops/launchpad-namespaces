package LaunchpadNamespaces

#repositories: {
	"graphops": {
		url: "https://graphops.github.io/launchpad-charts/canary"
		description: """
			lorem ipsolum
			"""
		_renovate: {
			ignoreUnstable: false
		}
		charts: {
			erigon: {
				url: "https://github.com/ledgerwatch/erigon"
				description: """
					Erigon is an implementation of Ethereum (execution client with light client for consensus layer), on the efficiency frontier.
					"""
			}
			nimbus: {
				url: "https://github.com/status-im/nimbus-eth2"
				description: """
					Nimbus-eth2 is an extremely efficient consensus layer (eth2) client implementation.
					"""
			}
			proxyd: {
				url: "https://github.com/ethereum-optimism/infra/tree/main/proxyd"
				description: """
					Proxyd is an EVM-blockchain JSON-RPC router and load balancer developed in Go by Optimism. It is capable of load balancing, automatic failover, intelligent request routing and very basic caching.
					"""
			}
			heimdall: {
				url: "https://github.com/0xPolygon/heimdall-v2"
				description: """
					Validator node for Matic Network.
					"""
			}
			"heimdall-v2": {
				url: "https://github.com/0xPolygon/heimdall-v2"
				description: """
					Validator node for Matic Network.
					"""
			}
			celo: {
				url: "https://github.com/celo-org/celo-blockchain"
				description: """
					Official golang implementation of the Celo blockchain
					"""
			}
			"arbitrum-nitro": {
				url: "https://github.com/OffchainLabs/nitro/"
				description: """
					Nitro is the latest iteration of the Arbitrum technology. It is a fully integrated, complete layer 2 optimistic rollup system, including fraud proofs, the sequencer, the token bridges, advanced calldata compression, and more.
					"""
			}
			"arbitrum-classic": {
				url: "https://github.com/OffchainLabs/arbitrum-classic"
				description: """
					The old "classic" Arbitrum tech stack.
					"""
			}
			nethermind: {
				url: "https://github.com/NethermindEth/nethermind"
				description: """
					Nethermind is a high-performance, highly configurable full Ethereum protocol execution client built on .NET that runs on Linux, Windows, and macOS, and supports Clique, Aura, and Ethash.
					"""
			}
			"resource-injector": {
				url: "https://github.com/graphops/launchpad-charts/tree/main/charts/resource-injector"
				description: """
					Manage Raw Kubernetes Resources using Helm
					"""
			}
			"openebs-rawfile-localpv": {
				url:         "https://github.com/graphops/launchpad-charts/tree/main/charts/openebs-rawfile-localpv"
				description: "RawFile Driver Container Storage Interface"
			}
			"graph-node": {
				url: "https://github.com/graphprotocol/graph-node"
				description: """
					Graph Node is an open source Rust implementation that event sources the Ethereum blockchain to deterministically update a data store that can be queried via the GraphQL endpoint.
					"""
			}
			"graph-network-indexer": {
				url: "https://github.com/graphprotocol/indexer"
				description: """
					Graph protocol indexer components
					"""
			}
			"graph-toolbox": {
				url: "https://github.com/graphops/docker-builds/tree/main/dockerfiles/graph-toolbox"
				description: """
					Utility kit for interacting and managing the Graph indexer stack.
					"""
			}
			"subgraph-radio": {
				url: "https://github.com/graphops/subgraph-radio"
				description: """
					Gossip about Subgraphs with other Graph Protocol Indexers
					"""
			}
			"lighthouse": {
				url: "https://github.com/sigp/lighthouse"
				description: """
					An open-source Ethereum consensus client, written in Rust and maintained by Sigma Prime.
					"""
			}
		}
	}

	"ingress-nginx": {
		url:         "https://kubernetes.github.io/ingress-nginx"
		description: "ingress-nginx is an Ingress controller for Kubernetes"
		charts: {
			"ingress-nginx": {
				url:         "https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx"
				description: "ingress-nginx is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer."
			}
		}
	}

	"jetstack": {
		url:         "https://charts.jetstack.io"
		description: ""
		charts: {
			"cert-manager": {
				url: "https://github.com/cert-manager/cert-manager"
				description: """
					cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates.
					"""
			}
		}
	}

	"prometheus-community": {
		url:         "https://prometheus-community.github.io/helm-charts"
		description: "Prometheus Community Kubernetes Helm Charts"
		charts: {
			"kube-prometheus-stack": {
				url: "https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack"
				description: """
					Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules
					"""
			}
		}
	}

	"deliveryhero": {
		url: "https://charts.deliveryhero.io"
		description: """
			Delivery Hero are big fans of Kubernetes and use Helm extensively. Here we have collected a few charts that are used across our organisation.
			"""
		charts: {
			"node-problem-detector": {
				url:         "https://github.com/deliveryhero/helm-charts/tree/master/stable/node-problem-detector"
				description: "This chart installs a node-problem-detector daemonset. This tool aims to make various node problems visible to the upstream layers in cluster management stack."
			}

		}
	}

	"grafana": {
		url:         "https://grafana.github.io/helm-charts"
		description: ""
		charts: {
			promtail: {
				url:         "https://github.com/grafana/helm-charts/tree/main/charts/promtail"
				description: "Promtail is an agent which ships the contents of local logs to a Loki instance"
			}
			"loki-distributed": {
				url:         "https://github.com/grafana/helm-charts/tree/main/charts/loki-distributed"
				description: "Helm chart for Grafana Loki in microservices mode"
			}
		}
	}

	"postgres-operator-charts": {
		url:         "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
		description: ""
		charts: {
			"postgres-operator": {
				url:         "https://github.com/zalando/postgres-operator"
				description: "The Postgres Operator delivers an easy to run highly-available PostgreSQL clusters on Kubernetes (K8s) powered by Patroni."
			}
		}
	}

	"sealed-secrets": {
		url:         "https://bitnami-labs.github.io/sealed-secrets"
		description: "sealed secrets chart provided by Bitnami"
		charts: {
			"sealed-secrets": {
				url:         "https://github.com/bitnami/charts/tree/main/bitnami/sealed-secrets"
				description: "Sealed Secrets are 'one-way' encrypted K8s Secrets that can be created by anyone, but can only be decrypted by the controller running in the target cluster recovering the original object."
			}
		}
	}

	"openebs": {
		url: "https://openebs.github.io/charts"
		description: """
			OpenEBS Helm Repository:
			OpenEBS helps Developers and Platform SREs easily deploy Kubernetes Stateful Workloads that require fast and highly reliable container attached storage.
			"""
		charts: {
			openebs: {
				url:         "https://github.com/openebs/openebs"
				description: "OpenEBS is the leading open-source example of a category of cloud native storage solutions sometimes called Container Attached Storage."
			}
		}
	}

	"openebs-zfs-localpv": {
		url:         "https://openebs.github.io/zfs-localpv"
		description: "A Helm chart for openebs zfs localpv provisioner. This chart bootstraps OpenEBS ZFS LocalPV provisioner deployment on a Kubernetes cluster using the Helm package manager."
		charts: {
			"zfs-localpv": {
				url:         "https://github.com/openebs/zfs-localpv/tree/b70fb1e847b8c9ba32e3fd8cba877767686f6b26"
				description: "CSI driver for provisioning Local PVs backed by ZFS and more."
			}
		}
	}

	"openebs-monitoring": {
		url: "https://openebs.github.io/monitoring/"
		description: """
			A Helm chart for OpenEBS monitoring. This chart bootstraps OpenEBS monitoring stack on a Kubernetes cluster using the Helm package manager.
			"""
		charts: {
			"openebs-monitoring": {
				url:         "https://github.com/openebs/monitoring"
				description: "A set of Grafana dashboards and Prometheus alerts for OpenEBS that can be installed as a helm chart or imported as jsonnet mixin."
			}
		}
	}
}

// instantiate a #repositories object for internal usage
_repositories: {
	#repositories

	// link all charts to their repo and add name
	[repoName=string]: charts: [chartName=string]: {
		repository: "\(repoName)"
		name:       "\(chartName)"
	}
}
