#!/usr/bin/env bash

set -e

if [[ $(uname -s) == Linux ]]; then
    base_rpath="realpath"
elif [[ $(uname -s) == Darwin ]]; then
    base_rpath="grealpath"
fi

readonly BASEDIR="$(dirname -- "$0")"
readonly REPOROOT="$("$base_rpath" "$BASEDIR/../..")"
readonly GENOPENAPI="$("$base_rpath" "$REPOROOT/src/scripts/generate-openapi.sh")"
readonly DOCSDIR="$("$base_rpath" "$REPOROOT/src/docs")"
readonly TEMPLATESDIR="$("$base_rpath" "$DOCSDIR/macros")"

DATA_API_FILE="$(mktemp)"
exec 3>"$DATA_API_FILE"
exec 4<"$DATA_API_FILE"
rm "$DATA_API_FILE"
$GENOPENAPI -a >&3

DATA_CONST="$(cat "$DOCSDIR/constants.json")"
DATA="$(jq -s '. | add' <(cat <&4 | jq '.')  <(echo "$DATA_CONST" | jq '{ "const": . }'))"

for file in "$REPOROOT"/[a-zA-Z]*/README.md.tera; do
    dir="$(dirname -- "$file")"
    namespace="$(basename -- "$dir")"

    echo "$DATA" | tera --include-path "$TEMPLATESDIR" --template "$file" --stdin > "$dir/README.md"
    git add "$dir/README.md"
done


for file in "$DOCSDIR"/*.tera; do
    filename="$(basename -- "$file")"

    echo "$DATA" | tera --include-path "$TEMPLATESDIR" --template "$file" --stdin > "$REPOROOT/${filename%.tera}"
    git add "$REPOROOT/${filename%.tera}"
done
