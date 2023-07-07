#!/usr/bin/env bash

readonly BASEDIR="$(dirname -- "$0")"
readonly REPOROOT="$(realpath "$BASEDIR/../..")"
readonly GENOPENAPI="$(realpath "$BASEDIR/generate-openapi.sh")"
readonly SCHEMAS_DIR=$(realpath "$REPOROOT/src/schemas")

$GENOPENAPI > "$REPOROOT/schema.json"

function gen-helmfile {
   namespace=$1

   pushd "$SCHEMAS_DIR"
   cue cmd -t namespace="$namespace" build:helmfile > "$REPOROOT/$namespace/helmfile.yaml"
   git add "$REPOROOT/$namespace/helmfile.yaml"
   popd
}

for file in $REPOROOT/src/schemas/*.cue; do
   namespace=$(grep -Po "schema:namespace=.*?([[:space:]]|$)" "$file" | cut -d '=' -f 2)
   if [[ -n $namespace ]]; then
     gen-helmfile "$namespace"
   fi
   unset namespace
done
