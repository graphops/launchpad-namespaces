#!/usr/bin/env bash

set -ex

get_realpath() {
  local target_file="$1"

  # Check if 'realpath' exists
  if command -v realpath >/dev/null 2>&1; then
    realpath "$target_file"
  elif command -v grealpath >/dev/null 2>&1; then
    grealpath "$target_file"
  else
    echo "Neither realpath nor grealpath is installed. Exiting."
    exit 1
  fi
}

readonly BASEDIR="$(dirname -- "$0")"
readonly REPOROOT="$(get_realpath "$BASEDIR/../..")"
readonly GENOPENAPI="$(get_realpath "$REPOROOT/src/scripts/generate-openapi.sh")"
readonly DOCSDIR="$(get_realpath "$REPOROOT/src/docs")"
readonly TEMPLATESDIR="$(get_realpath "$DOCSDIR/macros")"

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
