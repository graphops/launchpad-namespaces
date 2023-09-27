package LaunchpadNamespaces

import (
	"tool/cli"
	"encoding/json"
	"encoding/yaml"
	"strings"
)

command: {
	"build:helmfile": {
		var: {
			namespace: string @tag(namespace)
		}
		_out:  _helmfile.#render & {_namespace: var.namespace}
		print: cli.Print & {text:               _out.out}
	}
	"build:renovate": {
		_out:  _renovate.render
		print: cli.Print & {text: _out.out}
	}
}

_renovate: {
	_#repo: {
		_repo:   string
		_url:    _repositories[_repo].url
		_struct: {
			matchDepPatterns: "\(_repo)\\/.*"
			registryUrls: ["\(_url)"]
		} & {if _repositories[_repo]._renovate != _|_ {_repositories[_repo]._renovate}}
		render: json.Marshal(_struct)
		out:    strings.Join([ for line in strings.Split(render, "\n") {"      " + line}], "\n")
	}
	render: {
		_blocks: [ for repoName, _ in _repositories {_#repo & {_repo: repoName}}]
		out: strings.Join([ for block in _blocks {block.out}], ",\n")
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

		_defaultFlavor: _helmfile._#defaultFlavor & {_namespace: this}
		defaultFlavor:  _defaultFlavor.out

		_defaultFeatures: _helmfile._#defaultFeatures & {_namespace: this}
		defaultFeatures:  _defaultFeatures.out

		_defaultScaling: _helmfile._#defaultScaling & {_namespace: this}
		defaultScaling:  _defaultScaling.out

		_environment: _helmfile._#environment & {_namespace: this}
		environment:  _environment.out

		_defaultNamespace: _helmfile._#defaultNamespace & {_namespace: this}
		defaultNamespace:  _defaultNamespace.out

		_labels: _helmfile._#labels & {_namespace: this}
		labels:  _labels.out

		_templates: _helmfile._#templates & {_namespace: this}
		templates:  _templates.out

		_releases: _helmfile._#releases & {_namespace: this}
		releases:  _releases.out

		_repos:       _helmfile._repos & {_namespace: this}
		repositories: _repos.out

		out: strings.Join([
			defaultFlavor,
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

		_render:   yaml.Marshal([ for repoName, repo in repositoriesSet {repo}])
		_indented: strings.Join([ for line in strings.Split(_render, "\n") {"  " + line}], "\n")

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

	_#defaultFlavor: {
		this=_namespace: string
		out:             *"" | string
		if _namespaces[this].values.flavor != _|_ {
			out: """
				#set default flavor when missing
				{{ if not ( hasKey .Values \"flavor\" ) }}
				{{ $_ := set .Values \"flavor\" "\(_namespaces[this].values.flavor)" }}
				{{ end }}

				"""
		}
	}

	_#defaultFeatures: {
		this=_namespace: string
		out:             *"" | string
		if _namespaces[this].values.features != _|_ {
			_features: strings.Join([ for feat in _namespaces[this].values.features {"`\(feat)`"}], "\n")
			out:       """
				# Define default features when undefined
				{{ if not (hasKey .Values "features") }}
				{{ $_ := set .Values "features" (list
				\(_features)
				) }}
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
				{{ $_ := set .Values \"scaling\" dict }}
				{{ end }}
				{{ if not ( hasKey ( .Values | get "scaling" dict ) \"deployments\" ) }}
				{{ $_ := set .Values.scaling \"deployments\" \(_namespaces[this].values.scaling.deployments) }}
				{{ end }}

				"""
		}
	}

	_#environment: {
		this=_namespace: string

		_variables: {
			if _namespaces[this].values.flavor != _|_ {
				flavor: "{{ .Values.flavor }}"
			}
			if _namespaces[this].values.features != _|_ {
				features: "{{ .Values.features | toYaml | nindent 10 }}"
			}
			if _namespaces[this].values.scaling != _|_ {
				scaling: deployments: "{{ .Values.scaling.deployments }}"
			}
		}

		_yaml:       yaml.Marshal({environments: "{{ .Environment.Name }}": values: [ for key, value in _variables {(key): value}]})
		_yamlCleanP: strings.Replace(_yaml, "'{{", "{{", -1)
		_yamlCleanS: strings.Replace(_yamlCleanP, "}}'", "}}", -1)
		_yamlClean:  _yamlCleanS
		out:         _yamlClean
	}

	_#defaultNamespace: {
		this=_namespace: string
		if _namespaces[this].values._templatedTargetNamespace != _|_ {
			out: """
				#set default namespace
				{{ $_defaultNamespace := \(_namespaces[this].values._templatedTargetNamespace) }}

				"""
		}
		if _namespaces[this].values._templatedTargetNamespace == _|_ {
			out: """
			#set default namespace
			{{ $_defaultNamespace := `\(_namespaces[this].values.targetNamespace)` }}

			"""
		}
	}

	_#labels: {
		this=_namespace: string

		_commonLabels: {
			for key, value in _namespaces[this].labels {"\(key)": value}
		}
		commonLabels: yaml.Marshal({commonLabels: _commonLabels})

		_dictLabels: [ for key, value in _commonLabels {"  `\(key)` `\(value)`"}]
		dictLabels: strings.Join(_dictLabels, "\n")

		out: strings.Join([
			commonLabels,
			"{{ $_labels := dict ",
			dictLabels,
			"}}",
		], "\n")
	}

	_#templates: {
		this=_namespace: string
		_blocks: {
			transforms: """
				transforms:
				  {{ tpl $_tplTransforms (dict
				  "annotations" ( .Values | get "annotations" dict)
				  "labels" ( merge $_labels ( .Values | get "labels" dict) )
				  ) | nindent 4 }}

				"""
		}
		_default: {
			defaults: {
				_defaults.releases
				namespace: """
					{{ .Values | get "targetNamespace" $_defaultNamespace }}
					"""
				inherit: [ {template: "transforms"}]
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

					if yaml.Marshal(_template) != "{}" {
						template: """
							  \(yaml.Marshal(_template))
							"""
					}

					if yaml.Marshal(_template) == "{}" {
						template: ""
					}

					out: strings.Join([releaseBlock, version, releaseBlock["\(releaseName)"].template], "\n")
				}
			}

			_blocks: {
				"\(releaseName)": _releaseBlock["\(releaseName)"].out
			}
		}

		_allblocks:      strings.Join([ for name, block in _blocks {block}], "\n")
		_indentedBlocks: strings.Join([ for line in strings.Split(_allblocks, "\n") {"  " + line}], "\n")

		out: strings.Join(["templates:", _indentedBlocks], "\n")
	}

	_#release: {
		this=_release: string
		scale=_scale:  *false | bool

		_blocks: {
			release: """
				- name: "{{ $release }}"
				  inherit:
				  - template: "{{ $canonicalRelease }}"
				  values:
				  {{- tpl $_tplReleaseValues (dict "Values" $.Values "canonicalRelease" $canonicalRelease "release" $release) | indent 4 -}}
				"""

			if scale {
				header: """
				{{- $canonicalRelease := "\(this)" }}
				{{- range $index := until .Values.scaling.deployments }}
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
				_release: releaseName
			}}}
			if _namespaces[this].values.scaling.deployments != _|_ {if release._scale {
				_props: {"\(releaseName)": {#properties: {
					...
					_scale: true
				}}}
			}}

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

		_allblocks:      strings.Join([ for name, block in _blocks {block}], "\n")
		_indentedBlocks: strings.Join([ for line in strings.Split(_allblocks, "\n") {"  " + line}], "\n")

		out: strings.Join(["releases:", _indentedBlocks], "\n")
	}
}

_templateBlocks: {
	transforms: """
		{{- $_tplTransforms := `
		{{- $_TemplatedResources := list "Deployment" "StatefulSet" "DaemonSet" -}}
		transformers:
		- apiVersion: builtin
		  kind: AnnotationsTransformer
		  metadata:
		    name: AddAnnotations
		  annotations:
		  {{- . | get "annotations" dict | toYaml | nindent 6 }}
		  fieldSpecs:
		  - path: metadata/annotations
		    create: true
		  {{- range $kind := $_TemplatedResources }}
		  - kind: {{ $kind }}
		    path: spec/template/metadata/annotations
		    create: true
		  {{- end }}
		- apiVersion: builtin
		  kind: LabelTransformer
		  metadata:
		    name: AddLabels
		  labels:
		  {{- . | get "labels" dict | toYaml | nindent 6 }}
		  fieldSpecs:
		  - path: metadata/labels
		    create: true
		  {{- range $kind := $_TemplatedResources }}
		  - kind: {{ $kind }}
		    path: spec/template/metadata/labels
		    create: true
		  {{- end }}
		` -}}

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
