# Contributing to *Launchpad Namespaces*

Hello! :wave: and thank you for considering investing your time in contributing to Launchpad Namespaces! As an open source project, it depends on a strong community to florish, and we welcome any type of contribution (not just code) that aligns with our [Code of Conduct].

Some of the ways to contribute:
- **Community:** by hanging with our community at ![Discord](https://avatars.githubusercontent.com/u/1965106?s=12&v=4) [Discord *(The Graph)*](https://discord.com/channels/438038660412342282/1029379955307585568), even if just to let us know you're using *Namespaces* we would appreciate to hear from you. We don't bite, promise!
- **Opening Issues:** by being a user and taking the time to report issues (or feature requests) you've ran into. Please see the [Opening Issues](/CONTRIBUTING.md#opening-issues) section below on how to do just that.
- **Code:** by channeling your skills and knowledge to craft valuable pull requests (PRs). We wholeheartedly welcome your contributions. Please see the [Contributing Code](/CONTRIBUTING.md#contributing-code) section below on how to do just that.

# Opening Issues


# Contributing Code

## Requirements

To contribute code, there's a few requirements you need to go through first:

### yarn

Our Git hooks system and some of our dependencies for tasks such as code generating or templating are being managed by [*yarn*](https://github.com/yarnpkg/berry), so that will be required

### tera-cli

Some of our documentation is templated with this tool, and for those tasks to run sucessfully [*tera-cli*](https://github.com/chevdor/tera-cli) must be available

### CUE

Namespaces schemas are written in [CUE](https://cuelang.org) and you will need this tool, follow the upstream guide on how to install it: [CUE *Installation*](https://github.com/cue-lang/cue#download-and-install)

Once you have successfully fulfilled the previous requirements in your operating system, the next logical step is to clone this repository and initialize the yarn packages using the following command:

> yarn install

You're all set up and ready to go! Continue reading for conventions and a concise overview of the repository layout and implementation details.

## Commit messages and pull requests

We follow [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).

In brief, each commit message consists of a header, with optional body and footer:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

`<type>` must be one of the following:
- feat: A new feature
- fix: A bug fix
- docs: Documentation only changes
- style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- refactor: A code change that neither fixes a bug nor adds a feature
- perf: A code change that improves performance
- test: Adding missing tests
- chore: Changes to the build process or auxiliary tools and libraries such as documentation generation
- revert: If the commit reverts a previous commit, contains the header of the reverted commit.

Make sure to include an exclamation mark after the commit type and scope if there is a breaking change.

`<scope>` optional and could be anything that specifies the place of the commit change, e.g. solver, [filename], tests, lib, ... we are not very restrictive on the scope. The scope should just be lowercase and if possible contain of a single word.

`<description>` contains succinct description of the change with imperative, present tense. don't capitalize first letter, and no dot (.) at the end.

`<body>` include the motivation for the change, use the imperative, present tense

`<footer>` contain any information about Breaking Changes and reference GitHub issues that this commit closes

Commits in a pull request should be structured in such a way that each commit consists of a small logical step towards the overall goal of the pull request. Your pull request should make it as easy as possible for the reviewer to follow each change you made. For example, it is a good idea to separate simple mechanical changes like renaming a method that touches many files from logic changes. Your pull request should not be structured into commits according to how you implemented your feature, often indicated by commit messages like 'Fix problem' or 'Cleanup'. Flex a bit, and make the world think that you implemented your feature perfectly, in small logical steps, in one sitting without ever having to touch up something you did earlier in the pull request. (In reality, that means you'll use `git rebase -i` a lot).

Please do not merge the remote branch into yours as you develop your pull request; instead, rebase your branch on top of the latest remote if your pull request branch is long-lived.

## Release process

> **Warning**
> w.i.p: GitHub Workflows still being worked out

## Repository Layout

### `/src`

This repository has a lot of dynamically generated content and artifacts, and the source of truth for all of those resides in /src

### `/src/schemas`

In here you'll discover a collection of schemas which are the source of truth for each namespace helmfile. Amongst them also resides `generate_tool.cue`, which implements the logic for actually generating all the outputs from the schemas.

### `/src/scripts`

Here, you will find a repository containing convenient scripts for regenerating helmfiles, documentation, OpenAPI JSON schema files, and more. These scripts are designed to streamline the process and make it easier for you to update and maintain these essential components.

### `/src/docs`

Here, you will find base templates for several document files, and some macros used in the templating.

### `/<namespace>`

Each namespace has its own folder where their specific artifacts reside

### `/<namespace>/values`

The default values for a given namespace. In case the namespace has more than one flavor (different sets of defaults), then those reside in `/<namespace>/values/<flavor>`, and the `_common` folder contains the common values shared by all flavors.

## Implementation Details

A Namespace is comprised of two things:
- A set (or more, when the namespace has different flavors) of default values for the releases (helm charts)
- A `helmfile.yaml` file that incorporates client-side templating logic, evaluated dynamically by helmfile during runtime. This templating logic provides a rich set of features and interfaces, such as dictionary merging of user-provided values with default values, as well as the ability to toggle specific releases on or off based on feature requirements. It empowers you to efficiently customize and configure your deployments with ease.

The default values are static data, and can be found in the `{namespace}/values` folders.

The helmfile.yaml file is dynamically built from schema files written in CUE (check the repository layout for a more comprehensive description of the structure).

The schema files completely define the namespace in its many characteristics, such as:
- what releases they bundle, and the helm chart repos in which to find those releases
- the features it supports
- the labels its releases get deployed with

### values merging

This is often implemented in the helmfiles in code such as
```
{{ $__helmDefaults := `{"recreatePods":true}` | fromJson }}
{{ with ( .Values | get "helmDefaults" dict ) }}
{{ $_ := (deepCopy . | mergeOverwrite $__helmDefaults) }}
{{ end }}
```
which consists of declaring a variable holding a default value, and deep merging with the user passed values, giving precedence to those. Injecting the default value, recreatePods in this example, is done by the CUE tool when building the helmfiles.

### flavors

Flavors are implemented by having different sets of values in different subfolders, and having the helmfile lookup the folder dynamically, as shown in this example
```
{{- if ( hasKey .Values "flavor" ) }}
- ./values/_common/{{` "`{{ .Release.Name }}`" `}}.yaml
- ./values/{{ .Values.flavor }}/{{` "`{{ .Release.Name }}`" `}}.yaml
{{- else }}
- ./values/{{` "`{{ .Release.Name }}`" `}}.yaml
{{- end -}}
```
### features

Features are implemented by wrapping the releases in the helmfile with a conditional, as seen in the following example:
```
{{ if has "metrics" ( .Values | get "features" list ) }}
{{- $release := "kube-prometheus-stack" }}
- name: 'kube-prometheus-stack'
  inherit:
  - template: 'kube-prometheus-stack'
  values:
  {{- tpl $_tplReleaseValues (dict "Values" .Values "release" $release)  | indent 4 -}}
{{- end -}}
```
## How To

### Add helm chart repositories, and charts

The source of truth for those is kept in `src/charts.cue`, which contains a structure of repositories, and the charts they contain.
You just need to add more (or change them) following the pattern that is being used and taking care to include the metadata fields (descriptions, url, ...)

The structure looks like this:
```
#repositories: {
	"<repository name>": {
		url: "<relevant repository URL>"
		description: """
			Relevant repository description
			lorem ipsolum
			"""
		charts: {
			<chart name>: {
				url: "<relevant chart URL>"
				description: """
					Relevant chart description
					lorem ipsolum
					"""
			}
```

After changing this file, the docs, helmfiles and OpenAPI JSON schema should all be updated. Either by the pre-commit hook or
by running the appropriate scripts manually (keep reading for more on those).

### Add a new *Namespace*

For doing this, you need two things:
- Create a new schema file in `src/schemas/<namespace-name>.cue`
- Add a README.md.tera file to the `<namespace-name>/` folder

To create the schema file, the easiest approach would be to duplicate an existing one and adjust as required.

It is important that the file has this comment line:
```
// schema:type=namespace schema:namespace=<namespace name>
```

and has this block:
```
// instantiate namespace ojects for internal usage
_namespaces: "ethereum": _#namespaceTemplate & {_key: #namespaces.#ethereum}
```

The rest is namespace specific in terms of what releases it includes, and if it supports features or flavors, and so on.
Any included releases must link to what's defined in the `charts.cue` file via the `_repositories` struct, like so:
```
		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				_template: {version: "0.6.0"}
			}
```
so, if you need to add new repositories and charts, see the previous section about how to do just that.

To add the README.md.tera file, you can also just copy any of the existing ones in other namespaces, and take care to adjust this line appropriately:
```
{% set name = "<namespace name>" %}
```
> **Note**
> The following tasks are all run by the husky pre-commit git hook, so you don't need to run them yourself unless you're developing
> and want to do that without commiting, or have any other reason for it.

### Build a *Namespace* helmfile.yaml from the schema

Provided you already have the `cue` command installed and available, you should go into the `src/schemas` folder (needs to be run from that directory) and run:
```shell
cue cmd -t namespace="<namespace>" build:helmfile
```
so, i.e. for the ethereum namespace you'd run:
```shell
cue cmd -t namespace="ethereum" build:helmfile
```

and should get the helmfile.yaml as output

### Update the docs

We have a script that automates that task under `src/scripts/update-docs.sh`.
Provided you have all the requisites installed (you ran `yarn install` and you have tera-cli available), you can just run it and it will
update the OpenAPI JSON schema, template all the documentation, and do git add on those

### Update the OpenAPI JSON schema at `schema.json`

We have a script that generates the OpenAPI schema under `src/scripts/generate-openapi.sh`. You should be able to run it and you will get it as output.

