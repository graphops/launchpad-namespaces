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
			_templateBlocks.transforms,
			_templateBlocks.releaseValues,
			helmDefaults,
			kubeVersion,
			defaultFlavor,
			defaultFeatures,
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
			_blocks: {
				"\(releaseName)": yaml.Marshal( {
					"\(releaseName)": {
						chart: "\(release.chart.repository)/\(release.chart.name)"
						release._template
						inherit: [ {template: "defaults"}]
					}
				})
			}
		}

		_allblocks:      strings.Join([ for name, block in _blocks {block}], "\n")
		_indentedBlocks: strings.Join([ for line in strings.Split(_allblocks, "\n") {"  " + line}], "\n")

		out: strings.Join(["templates:", _indentedBlocks], "\n")
	}

	_#release: {
		this=_release: string
		out:           """
			{{- $release := "\(this)" }}
			- name: '\(this)'
			  inherit:
			  - template: '\(this)'
			  values:
			  {{- tpl $_tplReleaseValues (dict "Values" .Values "release" $release)  | indent 4 -}}
			"""
	}

	_#releases: {
		this=_namespace: string
		_blocks: {}
		for releaseName, release in _namespaces[this].releases if release.feature == _|_ {
			temp = "_\(releaseName)": _#release & {_release: releaseName}
			_blocks: {
				_
				"\(releaseName)": temp.out
			}
		}
		for releaseName, release in _namespaces[this].releases if release.feature != _|_ {
			temp = "_\(releaseName)": _#release & {_release: releaseName}
			_blocks: {
				"_\(releaseName)": strings.Join([
							"{{ if has \"\(release.feature)\" ( .Values | get \"features\" list ) }}",
							temp.out,
							"{{- end -}}",
				], "\n")
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
		- ./values/_common/{{` "`{{ .Release.Name }}`" `}}.yaml
		- ./values/{{ .Values.flavor }}/{{` "`{{ .Release.Name }}`" `}}.yaml
		{{- else }}
		- ./values/{{` "`{{ .Release.Name }}`" `}}.yaml
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
