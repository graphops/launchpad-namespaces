package helmfile

// Helmfile config schema
@jsonschema(schema="http://json-schema.org/draft-07/schema#")
// null | bool | number | string | [...] | {
{
	// Configure a fixed list of API versions to pass to 'helm
	// template' via the --api-versions flag with the below:
	apiVersions?: [...string]
	bases?: [...string & string]

	// The list of environments managed by helmfile.
	environments?: {
		{[=~"[a-zA-Z\\d_-]+" & !~"^()$"]: #environment}
		...
	} | *{
		default: {
			...
		}
		...
	}

	// these labels will be applied to all releases in a Helmfile.
	// Useful in templating if you have a helmfile per environment or
	// customer and don't want to copy the same label to each release
	commonLabels?: #map

	// Path to alternative helm binary (--helm-binary)
	helmBinary?:   string
	helmDefaults?: #helmDefaults
	helmfiles?: [...#helmfile]
	hooks?: [...#hook]
	missingFileHandler?: #missingFileHandler

	// Helmfile runs various helm commands to converge the current
	// state in the live cluster to the desired state defined here.
	releases?: [...#release]
	repositories?: [...#repository]
	...
}

#repository: {
	name:             string
	url?:             string
	certFile?:        string
	keyFile?:         string
	caFile?:          string
	username?:        string
	password?:        string
	oci?:             bool
	passCredentials?: bool
	...
}

#helmDefaults: {
	tillerNamespace?: string
	tillerless?:      bool
	kubeContext?:     string
	cleanupOnFail?:   bool
	args?: [...string & string]
	verify?:       bool
	wait?:         bool
	waitForJobs?:  bool
	timeout?:      number
	recreatePods?: bool
	force?:        bool
	tls?:          bool
	tlsCACert?:    string
	tlsCert?:      string
	tlsKey?:       string

	// limit the maximum number of revisions saved per release. Use 0
	// for no limit.
	historyMax?:      number | *10
	createNamespace?: bool
	...
}

#release: {
	atomic?:          bool
	chart:            string
	cleanupOnFail?:   bool | *false
	condition?:       string
	createNamespace?: bool

	// if used with charts museum allows to pull unstable charts for
	// deployment, for example: if 1.2.3 and 1.2.4-dev versions exist
	// and set to true, 1.2.4-dev will be pulled (default false)
	devel?:                      bool | *false
	disableValidation?:          bool
	disableValidationOnInstall?: bool
	disableOpenAPIValidation?:   bool
	force?:                      bool
	historyMax?:                 number
	hooks?: [...#hook]
	installed?: (bool | string | {
		...
	}) & (bool | string | {
		...
	})
	kubeContext?:        string
	labels?:             #map
	missingFileHandler?: #missingFileHandler
	name:                string
	namespace?:          string
	recreatePods?:       bool
	secrets?: [...string]
	set?: [...({
		name?: string
		file?: string
		...
	} | {
		name?: string
		values?: [...number & number]
		...
	} | {
		name?:  string
		value?: string
		...
	}) & {
		...
	}]

	// When set to `true`, skips running `helm dep up` and `helm dep
	// build` on this release's chart.
	skipDeps?:        bool | *false
	tillerNamespace?: string
	tillerless?:      bool
	timeout?:         number
	tls?:             bool
	tlsCACert?:       string
	tlsCert?:         string
	tlsKey?:          string
	values?: [...(string | #map) & _]
	verify?:      bool
	version?:     (string | number | int) & (number | string)
	wait?:        bool
	waitForJobs?: bool
	...
}

#helmfile: (string | {
	path: string
	selectors?: [...string & string]
	values?: [...(string | {
		key1?: string
		...
	}) & (string | {
		...
	})]
	...
}) & (string | {
	...
})

#missingFileHandler: "Error" | "Warn" | "Info" | "Debug"

#environment: {
	values?: [...(string | #map) & _]
	secrets?: [...string]
	missingFileHandler?: #missingFileHandler
	kubeContext?:        string
	...
}

#hook: {
	events?: [...string]
	showlogs?: bool
	command?:  string
	args?: [...(string | string) & string]
	...
}

#map: {
	{[=~"[a-zA-Z\\d_-]+" & !~"^()$"]: ({
						...
	} | bool | string | [...] | null | int) & (null | bool | string | [...] | {
		...
	})
	}
	...
}
