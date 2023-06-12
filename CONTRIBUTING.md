
Thank you for considering investing your time in contributing to Launchpad Namespaces! As an open source project it depends on a strong community to florish, and we welcome any type of contribution (not just code) that aligns with our [Code of Conduct].
Some of the ways to contribute:

- Community:
- Opening issues: by being a user and taking the time to report issues you've ran into. Please see the opening issues section below, on how to do that.
- Code:

# Opening an Issue

# Contributing Code

To contribute code, there's a few requirements we need to go trough first:

## yarn

Our Git hooks system and some of our dependencies for tasks such as code generating or templating have being managed by yarn, so that will be required

## Tera

Some of our documentation is templated with this tool, and for those tasks to run sucessfully Tera-cli must be available

## CUE

Namespaces schemas are written in cue-lang and you will need this


After having taken care of satisfying the previous requirements in an appropriate way in your OS, your next step should be to clone this repository and initialize it with
> yarn init

From a setup point of view you should be ready to go. Keep reading for a brief overview of the repository layout and implementation details.

## Implementation Details

A Namespace artifact ammounts to two things:
- A set (or more, when the namespace has different flavors) of default values data
- An helmfile.yaml with some templating logic evaluated client-side "at runtime", by helmfile. This templating logic is mostly responsible for merging the user-passed values on top of the default ones

The default values are static data, and can be found in the {namespace}/values folders. If the namespace supports "flavors", each flavor corresponds to a subfolder named appropriately, and the _common folder contains values shared by all flavors of that namespace.

Besides the values, the namespaces' helmfile is defined by parameters such as:
- what releases they bundle, and the helm chart repos in which to find those releases
- what features it supports
- the labels its releases get deployed with
- ...

Those are all defined by the namespace's schema, at _gen/schemas/{namespace}.cue.
For each namespace, a CUE script generates the helmfile.yaml from that namespace's schema. So if one would like to modify something about that namespace.

That helmfile.yaml

## Repository Structure

