#!/usr/bin/env bash

readonly PROGNAME="$(basename -- "$0")"
readonly BASEDIR="$(dirname -- "$0")"
readonly CUEROOT="$(realpath "$BASEDIR/../")"
readonly SCHEMA_PKG="graphops.xyz/launchpad/namespaces/schemas:LaunchpadNamespaces"

RESOLVEREFS="cat"
MERGEALLOF="cat"

usage="${PROGNAME}
where:
    -h, --help           Show this help text
    -r, --refs           Render the OpenAPI spec with all '$refs' resolved
    -a, --allOf          Renders the OpenAPI spec with all allOf elements merged into their objects. Implies resolving refs as well.
examples:
    ${PROGNAME} -a"

while [ "$#" -gt 0 ]
do
    case "$1" in
    -r|--refs)
        RESOLVEREFS="resolve_refs"
        ;;
    -a|--allOf)
        RESOLVEREFS="resolve_refs"
        MERGEALLOF="merge_allOf"
        ;;
    -h|--help)
        echo "$usage"
        exit 0
        ;;
    --)
        break
        ;;
    -*)
        echo "Invalid option '$1'. Use --help to see the valid options" >&2
        exit 1
        ;;
    *)  ;;
    esac
    shift
done

function cue_export {
    local cue_pkg;
    (cd "$CUEROOT"; cue export --out json+openapi "$SCHEMA_PKG")
}

function resolve_refs {
  input="${1:-$(</dev/stdin)}";
  echo "$input" > /tmp/swagger-input.json
  yarn swagger-cli bundle -r /tmp/swagger-input.json
  rm /tmp/swagger-input.json
}

function merge_allOf {
  input="${1:-$(</dev/stdin)}";

  local jqcmd='. as $root'
  # first, let's get a list of all the nodes that have an "allOf" child.
  jqcmd+=' | $root | keys | map($root | paths(.)) | map(if (. | index("allOf")) then . else null end) | reduce .[] as $item ([]; if $item != null then . + [$item + [$item | rindex("allOf")]] else . end) | select(. != null) | map(.[:(.[-1])]) | unique as $nodes'
  # next, combine all of the items in allOf array, and merge those on the parent object. Save results in an object with the format { node-path, result-object  }
  jqcmd+=' | $nodes | map( . as $node | [ $node, ( $root | getpath($node) ), ( $root | getpath($node).allOf | add ) ] ) | map( . as $result | [ $result[0], ( $result[2] * $result[1] ) ] ) | . as $results'
  # do a "fake reduce" to iterate over each element in previous result, and on every path replace the original object with the resulting one after merging allOf
  jqcmd+=' | $results | sort_by(.[0] | length) | reverse | reduce .[] as $result ( $root;  ( . | setpath( $result[0]; $result[1] ) ) ) | . as $newroot'
  # lastly, walk the tree and delete every allOf element
  jqcmd+=' | $newroot | walk(if type == "object" then with_entries(select(.key == "allOf" | not)) else . end)'

  echo "$input" | jq "$jqcmd"
}

function main {
  cue_export | $RESOLVEREFS | $MERGEALLOF
}

main
