package LaunchpadNamespaces

import (
	"tool/cli"
	"encoding/yaml"
	//	"tool/exec"
	//	"tool/file"
)

command: gen: {
	defaults: {
		helmDefaults:    yaml.Marshal(_defaults.helmDefaults)
		releaseDefaults: yaml.Marshal(_defaults.releaseDefaults)
	}
	header: {
		print: cli.Print & {
			text: """
			    {{ $__helmDefaults := \"\(defaults.helmDefaults)\" | fromYaml}}
			"""
		}
	}
	test: {
		compute: {
			mystr: [ for key, val in namespaces.ingress.features {val}]
		}
		print: cli.Print & {
			text: "\(compute.mystr)"
		}
	}
}
