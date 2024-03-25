package LaunchpadNamespaces

import (
	"tool/cli"
	"encoding/json"
	"encoding/yaml"
	"strings"
	"list"
	"struct"
)

command: {
	"build:helmfile": {
		var: {
			namespace: string @tag(namespace)
		}
		_out: _helmfile.#render & {_namespace: var.namespace}
		print: cli.Print & {text: _out.out}
	}
	"build:renovate": {
		_out:                     _renovate.render
		print: cli.Print & {text: _out.out}
	}
}

_renovate: {
	_#repo: {
		_repo: string
		_url:  _repositories[_repo].url
		_struct: {
			matchDepPatterns: "\(_repo)\\/.*"
			registryUrls: ["\(_url)"]
		} & {if _repositories[_repo]._renovate != _|_ {_repositories[_repo]._renovate}}
		render: json.Marshal(_struct)
		out: strings.Join([for line in strings.Split(render, "\n") {"      " + line}], "\n")
	}
	render: {
		_blocks: [for repoName, _ in _repositories {_#repo & {_repo: repoName}}]
		out: strings.Join([for block in _blocks {block.out}], ",\n")
	}
}

_helmfile: {
	defaults: {
		helmDefaults: json.Marshal(_defaults.helmDefaults)
	}

	#render: {
		this=_namespace: string

		helmDefaults: _helmfile._helmDefaults.out

		kubeVersion: _helmfile._kubeVersion.out

		_setNamespaceDefaults: _helmfile._#setNamespaceDefaults & {_namespace: this}
		setNamespaceDefaults: _setNamespaceDefaults.out

		_defaultFlavor: _helmfile._#defaultFlavor & {_namespace: this}
		defaultFlavor: _defaultFlavor.out

		_defaultFeatures: _helmfile._#defaultFeatures & {_namespace: this}
		defaultFeatures: _defaultFeatures.out

		_defaultScaling: _helmfile._#defaultScaling & {_namespace: this}
		defaultScaling: _defaultScaling.out

		_environmentFlavor: _helmfile._#environmentFlavor & {_namespace: this}
		environmentFlavor: _environmentFlavor.out

		_environmentRuntimeDefaults: _helmfile._#environmentRuntimeDefaults & {_namespace: this}
		environmentRuntimeDefaults: _environmentRuntimeDefaults.out

		_environment: _helmfile._#environment & {_namespace: this}
		environment: _environment.out

		_defaultNamespace: _helmfile._#defaultNamespace & {_namespace: this}
		defaultNamespace: _defaultNamespace.out

		_labels: _helmfile._#labels & {_namespace: this}
		labels: _labels.out

		_templates: _helmfile._#templates & {_namespace: this}
		templates: _templates.out

		_releases: _helmfile._#releases & {_namespace: this}
		releases: _releases.out

		_repos: _helmfile._repos & {_namespace: this}
		repositories: _repos.out

		out: strings.Join([
			setNamespaceDefaults,
			defaultFlavor,
			environmentFlavor,
			"---",
			environmentRuntimeDefaults,
			"---",
			defaultFeatures,
			defaultScaling,
			environment,
			"---",
			_templateBlocks.transforms,
			_templateBlocks.releaseValues,
			helmDefaults,
			kubeVersion,
			defaultNamespace,
			labels,
			repositories,
			templates,
			releases,
		], "\n")
	}

	_repos: {
		this=_namespace: string
		_releaseRepositories: {}
		for releaseName, release in _namespaces[this].releases {
			_releaseRepositories: {
				"\(releaseName)": {
					name: release.chart.repository
					url:  _repositories[release.chart.repository].url
				}
			}
		}

		repositoriesSet: {
			for elem in _releaseRepositories {
				"\(elem.name)": elem
			}
		}

		_render: yaml.Marshal([for repoName, repo in repositoriesSet {repo}])
		_indented: strings.Join([for line in strings.Split(_render, "\n") {"  " + line}], "\n")

		out: strings.Join(["repositories:", _indented], "\n")
	}

	_helmDefaults: {out: """
		{{ $__helmDefaults := `\(defaults.helmDefaults)` | fromJson }}

		{{ with ( .Values | get \"helmDefaults\" dict ) }}
		{{ $_ := (deepCopy . | mergeOverwrite $__helmDefaults) }}
		{{ end }}

		helmDefaults:
		{{ $__helmDefaults | toYaml | indent 2 }}

		"""
	}

	_kubeVersion: {out: """
		{{ if ( hasKey .Values \"kubeVersion\" ) }}
		kubeVersion: {{ .Values.kubeVersion }}
		{{ end }}

		"""
	}

	_#setNamespaceDefaults: {
		this=_namespace: string

		_json:       json.Marshal(_namespaces[this].defaults)
		_jsonCleanP: strings.Replace(_json, "'{{", "{{", -1)
		_jsonCleanS: strings.Replace(_jsonCleanP, "}}'", "}}", -1)
		_jsonClean:  _jsonCleanS
		out:         """
			#namespace defaults
			{{ $_ := set .Values \"_namespaceDefaults\" ( `\(_jsonClean)` | fromJson ) }}
			"""
	}

	_#defaultFlavor: {
		this=_namespace: string
		out:             *"" | string
		if _namespaces[this].values.flavor != _|_ {
			out: """
				#set default flavor when missing
				{{ if not ( hasKey .Values \"flavor\" ) }}
				{{ $_ := set .Values \"flavor\" "\(_namespaces[this].defaults.flavor)" }}
				{{ end }}

				"""
		}
	}

	_#defaultFeatures: {
		this=_namespace: string
		out:             *"" | string
		if _namespaces[this].values.features != _|_ {
			out: """
				# Define default features when undefined
				{{ if not (hasKey .Values "features") }}
				{{ $_ := set .Values "features" .Values._defaults.features }}
				{{ end }}

				"""
		}
	}

	_#defaultScaling: {
		this=_namespace: string
		out:             *"" | string
		if _namespaces[this].values.scaling != _|_ {
			out: """
				#set default number of deployments when missing
				{{ if not ( hasKey .Values  "scaling" ) }}
				{{ $_ := set .Values "scaling" dict }}
				{{ end }}
				{{ if not ( hasKey ( .Values | get "scaling" dict ) \"deployments\" ) }}
				{{ $_ := set .Values.scaling "deployments" .Values._defaults.scaling.deployments }}
				{{ end }}

				"""
		}
	}

	_#environmentFlavor: {
		this=_namespace: string

		_variables: {}

		_variables: {
			if _namespaces[this].values.flavor != _|_ {
				flavor: "{{ .Values.flavor }}"
			}
			if _namespaces[this].defaults != _|_ {
				"_namespaceDefaults": "{{ .Values._namespaceDefaults | toYaml | nindent 10 }}"
			}
		}
		_yaml: yaml.Marshal({environments: "{{ .Environment.Name }}": values: [for key, value in _variables {(key): value}]})
		_yamlCleanP: strings.Replace(_yaml, "'{{", "{{", -1)
		_yamlCleanS: strings.Replace(_yamlCleanP, "}}'", "}}", -1)
		_yamlClean:  _yamlCleanS
		out:         _yamlClean
	}

	_#environmentRuntimeDefaults: {
		this=_namespace: string

		_variables: {}

		_variables: {
			if _namespaces[this].values.flavor == _|_ {
				"_defaults": "{{ .Values._namespaceDefaults.common | toYaml | nindent 10 }}"
			}
			if _namespaces[this].values.flavor != _|_ {
				"_defaults": "{{ .Values._namespaceDefaults | get .Values.flavor | toYaml | nindent 10 }}"
			}
		}

		_yaml: yaml.Marshal({environments: "{{ .Environment.Name }}": values: [for key, value in _variables {(key): value}]})
		_yamlCleanP: strings.Replace(_yaml, "'{{", "{{", -1)
		_yamlCleanS: strings.Replace(_yamlCleanP, "}}'", "}}", -1)
		_yamlClean:  _yamlCleanS
		out:         _yamlClean
	}

	_#environment: {
		this=_namespace: string

		_variables: {}

		_variables: {
			if _namespaces[this].values.features != _|_ {
				features: "{{ .Values.features | toYaml | nindent 10 }}"
			}
			if _namespaces[this].values.scaling != _|_ {
				scaling: deployments: "{{ .Values.scaling.deployments }}"
			}
		}

		_yaml: yaml.Marshal({environments: "{{ .Environment.Name }}": values: [for key, value in _variables {(key): value}]})
		_yamlCleanP: strings.Replace(_yaml, "'{{", "{{", -1)
		_yamlCleanS: strings.Replace(_yamlCleanP, "}}'", "}}", -1)
		_yamlClean:  _yamlCleanS
		out:         _yamlClean
	}

	_#defaultNamespace: {
		out: """
			#set default namespace
			{{ $_defaultNamespace := .Values._defaults.targetNamespace }}

			"""
	}

	_#tplStructToDict: {
		_dictName: string
		_struct: {...}
		_indent: *0 | int

		_elements: {
			for key, value in _struct if !strings.Contains("\(value)", "{{") {"\(key)": "`\(key)` `\(value)`"}
		}

		_templatedElementsList: list.SortStrings([for key, value in _struct if strings.Contains("\(value)", "{{") {"\(key)"}])

		_elements: {
			for index, key in _templatedElementsList {"\(key)": "`\(key)` $_templatedValue_\(index)"}
		}

		_elementsStrings: [for key, value in _elements {"\(value)"}]

		_variableDecl: [for index, key in _templatedElementsList let value = strings.Replace(strings.Replace(_struct[key], "{{", "", 1), "}}", "", 1) {
			"""
		{{- $_templatedValue_\(index) := \(value) }}
		"""
		}]

		_out: strings.Join([
			strings.Join(_variableDecl, "\n"),
			"{{- $\(_dictName) := dict ",
			strings.Join(_elementsStrings, "\n"),
			"}}",
		], "\n")

		if _indent == 0 {
			out: _out
		}

		if _indent > 0 {
			out: strings.Join([for line in strings.Split(_out, "\n") {" "*_indent + line}], "\n")
		}
	}

	_#tplStructToYaml: {
		_name: string
		_struct: {...}
		_indent: *0 | int

		_yaml: yaml.Marshal({"\(_name)": _struct})
		_yamlCleanP: strings.Replace(_yaml, "'{{", "{{", -1)
		_yamlCleanS: strings.Replace(_yamlCleanP, "}}'", "}}", -1)
		_yamlClean:  _yamlCleanS

		_out: _yamlClean

		if _indent == 0 {
			out: _out
		}

		if _indent > 0 {
			out: strings.Join([for line in strings.Split(_out, "\n") {" "*_indent + line}], "\n")
		}
	}

	_#labels: {
		this=_namespace: string

		_commonLabels: _#tplStructToDict & {
			_dictName: "_commonLabels"
			_struct:   _namespaces[this].labels
		}
		_commonResourceLabels: _#tplStructToDict & {
			_dictName: "_commonResourceLabels"
			_struct:   _namespaces[this].resourceLabels
		}

		out: strings.Join([
			_commonLabels.out,
			_commonResourceLabels.out,
			"""
				{{ $_ := mergeOverwrite $_commonResourceLabels $_commonLabels }}
				{{- if hasKey .Values "labels" }}
				{{- range $key, $value := $.Values.labels }}
				{{- $_ := set $_commonLabels $key $value }}
				{{- $_ := set $_commonResourceLabels $key $value }}
				{{- end }}
				{{- end }}
				{{- if hasKey .Values "resourceLabels" }}
				{{- range $key, $value := $.Values.resourceLabels }}
				{{- $_ := set $_commonResourceLabels $key $value }}
				{{- end }}
				{{- end }}
				""",
			"""
				commonLabels:
				{{- range $key, $value := $_commonLabels }}
				  {{ $key }}: {{ $value }}
				{{- end }}
				""",
		], "\n")
	}

	_#templates: {
		this=_namespace: string
		_default: {
			defaults: {
				_defaults.releases
				namespace: """
					{{ .Values | get "targetNamespace" $_defaultNamespace }}
					"""
			}
		}
		_blocks: {
			defaults: yaml.Marshal(_default)
		}

		for releaseName, release in _namespaces[this].releases {
			_releaseBlock: {
				"\(releaseName)": {
					_template: {for key, val in release._template if key != "version" {"\(key)": val}}

					releaseBlock: """
						\(releaseName):
						  {{- if ( .Values | get "\(releaseName)" dict | get "chartUrl" false ) }}
						  chart: {{ .Values | get "\(releaseName)" | get "chartUrl" }}
						  {{- else }}
						  chart: "\(release.chart.repository)/\(release.chart.name)"
						  {{- end }}
						  inherit:
						  - template: "defaults"
						"""

					version: """
						  {{- if ( .Values | get "\(releaseName)" dict | get "chartVersion" false ) }}
						  version: {{ .Values | get "\(releaseName)" | get "chartVersion" }}
						  {{- end }}
						  {{- if (not (or ( .Values | get "\(releaseName)" dict | get "chartVersion" false ) ( .Values | get "\(releaseName)" dict | get "chartUrl" false ) )) }}
						  version: "\(release._template.version)"
						  {{- end }}
						"""

					if struct.MinFields(_template, 1) {
						template: """
							  \(yaml.Marshal(_template))
							"""
					}

					if !struct.MinFields(_template, 1) {
						template: ""
					}

					out: strings.Join([releaseBlock, version, _releaseBlock["\(releaseName)"].template], "\n")
				}
			}

			_blocks: {
				"\(releaseName)": _releaseBlock["\(releaseName)"].out
			}
		}

		_allblocks: strings.Join([for name, block in _blocks {block}], "\n")
		_indentedBlocks: strings.Join([for line in strings.Split(_allblocks, "\n") {"  " + line}], "\n")

		out: strings.Join(["templates:", _indentedBlocks], "\n")
	}

	_#release: {
		this=_releaseName:      string
		_releaseLabels:         *"labels:" | string
		_releaseResourceLabels: *"{{- $_releaseResourceLabels := dict }}" | string
		scale=_scale:           *false | bool

		_blocks: {
			release: """
				\(_releaseResourceLabels)
				{{- $_releaseResourceLabels = mergeOverwrite $_commonLabels $_commonResourceLabels $_releaseResourceLabels }}
				- name: "{{ $release }}"
				  inherit:
				  - template: "{{ $canonicalRelease }}"
				  \(_releaseLabels)
				  {{- range $key,$value := ( $.Values | get $canonicalRelease dict | get "labels" dict ) }}
				    {{ $key }}: {{ $value }}
				  {{- $_ := set $_releaseResourceLabels $key $value }}
				  {{- end }}
				  {{- if (ne $release $canonicalRelease) }}
				  {{- range $key,$value := ( $.Values | get $release dict | get "labels" dict ) }}
				    {{ $key }}: {{ $value }}
				  {{- $_ := set $_releaseResourceLabels $key $value }}
				  {{- end }}
				  {{- end }}
				  {{- range $key,$value := ( $.Values | get $canonicalRelease dict | get "resourceLabels" dict ) }}
				  {{- $_ := set $_releaseResourceLabels $key $value }}
				  {{- end }}
				  {{- if (ne $release $canonicalRelease) }}
				  {{- range $key,$value := ( $.Values | get $release dict | get "resourceLabels" dict ) }}
				  {{- $_ := set $_releaseResourceLabels $key $value }}
				  {{- end }}
				  {{- end }}
				  {{- tpl $_tplTransforms (dict "Values" $.Values "release" $release "canonicalRelease" $canonicalRelease "resourceLabels" $_releaseResourceLabels  )  | indent 4 -}}
				  values:
				  {{- tpl $_tplReleaseValues (dict "Values" $.Values "canonicalRelease" $canonicalRelease "release" $release) | indent 4 -}}
				"""

			if scale {
				header: """
				{{- $canonicalRelease := "\(this)" }}
				{{- range $index := until (.Values.scaling | get $canonicalRelease dict | get "deployments" .Values.scaling.deployments) }}
				{{- $deploymentIndex := (add . 1) }}
				{{- $release := (printf "%s%v" "\(this)-" $deploymentIndex) }}
				"""
				end: """
					{{- end -}}
					"""
			}

			if !scale {
				header: """
			{{- $canonicalRelease := "\(this)" }}
			{{- $release := "\(this)" }}
			"""
				end:    ""
			}
		}

		out: strings.Join([_blocks.header, _blocks.release, _blocks.end], "\n")
	}

	_#releases: {
		this=_namespace: string

		_blocks: {}

		for releaseName, release in _namespaces[this].releases {
			_props: {"\(releaseName)": {#properties: {
				...
				_releaseName: releaseName
			}}}
			if _namespaces[this].values.scaling != _|_ {
				if list.Contains([for key, _ in _namespaces[this].values.scaling {key}], releaseName) {
					_props: {"\(releaseName)": {#properties: {
						...
						_scale: true
					}}}
				}}
			if release.labels != _|_ {
				_props: {"\(releaseName)": {#properties: {
					...
					_labels: {for key, value in release.labels {"\(key)": value}}
					_yamlLabels: yaml.Marshal(_labels)
					_indentedLabels: strings.Join([for line in strings.Split(_yamlLabels, "\n") {"    " + line}], "\n")
					_releaseLabels: strings.Join(["labels:", _indentedLabels], "\n")
				}}}
			}

			if release.labels != _|_ || release.resourceLabels != _|_ {
				_props: {"\(releaseName)": {#properties: {
					...
					_baseResourceLabels: {...}
					if release.labels != _|_ {
						_baseResourceLabels: {for key, value in release.labels {"\(key)": value}}
					}
					_#baseResourceLabels: {
						for key, value in _baseResourceLabels {"\(key)": *value | string}
					}
					_resourceLabels: {...}
					if release.resourceLabels != _|_ {
						_resourceLabels: _#baseResourceLabels & {for key, value in release.resourceLabels {"\(key)": value}}
					}
					if release.resourceLabels == _|_ {
						_resourceLabels: _#baseResourceLabels
					}
					_sReleaseResourceLabels: _#tplStructToDict & {
						_dictName: "_releaseResourceLabels"
						_struct:   _resourceLabels
					}
					_releaseResourceLabels: _sReleaseResourceLabels.out
				}}}
			}

			temp = "_\(releaseName)": _#release & {
				...
				_props["\(releaseName)"].#properties
			}

			if release.feature == _|_ {
				_blocks: {
					_
					"\(releaseName)": temp.out
				}
			}

			if release.feature != _|_ {
				_blocks: {
					"\(releaseName)": strings.Join([
						"{{ if has \"\(release.feature)\" ( .Values | get \"features\" list ) }}",
						temp.out,
						"{{- end -}}",
					], "\n")
				}

			}
		}

		_allblocks: strings.Join([for name, block in _blocks {block}], "\n")
		_indentedBlocks: strings.Join([for line in strings.Split(_allblocks, "\n") {"  " + line}], "\n")

		out: strings.Join(["releases:", _indentedBlocks], "\n")
	}
}

_templateBlocks: {
	transforms: """
		{{- $_tplTransforms := (print `
		{{- $_TemplatedResources := list "Deployment" "StatefulSet" "DaemonSet" -}}
		{{- $_labels := .resourceLabels }}
		{{- $_annotations := merge ( .Values | get .release dict | get "annotations" dict ) ( .Values | get .canonicalRelease dict | get "annotations" dict ) ( .Values | get "annotations" dict ) }}
		transformers:
		- apiVersion: builtin
		  kind: AnnotationsTransformer
		  metadata:
		    name: AddAnnotations
		  annotations:
		{{- $_annotations | toYaml | nindent 4 }}
		  fieldSpecs:
		  - path: metadata/annotations
		    create: true
		{{- range $kind := $_TemplatedResources }}
		  - kind: {{ $kind }}
		    path: spec/template/metadata/annotations
		    create: true
		{{- end }}
		  - path: spec/volumeClaimTemplates[]/metadata/annotations
		    kind: StatefulSet
		    create: true
		- apiVersion: builtin
		  kind: LabelTransformer
		  metadata:
		    name: AddLabels
		  labels:
		{{- $_labels | toYaml | nindent 4 }}
		  fieldSpecs:
		  - path: metadata/labels
		    create: true
		{{- range $kind := $_TemplatedResources }}
		  - kind: {{ $kind }}
		    path: spec/template/metadata/labels
		    create: true
		{{- end }}
		  - path: spec/volumeClaimTemplates[]/metadata/labels
		    kind: StatefulSet
		    create: true
		`) -}}
		"""

	releaseValues: """
		{{- $_tplReleaseValues := (print `
		{{- if ( .Values | get .release dict | get "mergeValues" true ) -}}
		{{- if ( hasKey .Values "flavor" ) }}
		- ./values/_common/{{ .canonicalRelease }}.yaml
		- ./values/_common/{{ .canonicalRelease }}.yaml.gotmpl
		- ./values/{{ .Values.flavor }}/{{ .canonicalRelease }}.yaml
		- ./values/{{ .Values.flavor }}/{{ .canonicalRelease }}.yaml.gotmpl
		{{- else }}
		- ./values/{{ .canonicalRelease }}.yaml
		- ./values/{{ .canonicalRelease }}.yaml.gotmpl
		{{- end -}}
		{{- if typeIs ( typeOf list ) ( .Values | get .canonicalRelease dict | get "values" dict ) -}}
		 {{- range $element := ( .Values | get .canonicalRelease dict | get "values" dict ) }}
		- {{- $element | toYaml | nindent 2 }}
		 {{- end -}}
		{{- else }}
		- {{- .Values | get .canonicalRelease dict | get "values" dict | toYaml | nindent 2 }}
		{{- end -}}
		{{- end -}}
		{{- if typeIs ( typeOf list ) ( .Values | get .release dict | get "values" dict ) -}}
		 {{- range $element := ( .Values | get .release dict | get "values" dict ) }}
		- {{- $element | toYaml | nindent 2 }}
		 {{- end -}}
		{{- else }}
		- {{- .Values | get .release dict | get "values" dict | toYaml | nindent 2 }}
		{{- end -}}
		`) -}}
		"""
}
