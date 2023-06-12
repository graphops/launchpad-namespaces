#!/usr/bin/env bash

readonly REPOROOT="$(dirname -- "$0")/../.."
readonly GENOPENAPI="$REPOROOT/_gen/scripts/generate-openapi.sh"
readonly DOCSDIR="$REPOROOT/_gen/docs"
readonly TEMPLATESDIR="$DOCSDIR/macros"

DATA=$($GENOPENAPI -a)

for file in $REPOROOT/[a-zA-Z]*/README.md.tera; do
    dir="$(dirname -- "$file")"
    namespace="$(basename -- "$dir")"

    echo "$DATA" | tera --include-path "$TEMPLATESDIR" --template "$file" --stdin > "$dir/README.md"
done


for file in $DOCSDIR/*.tera; do
    filename="$(basename -- "$file")"
    echo "$DATA" | tera --include-path "$TEMPLATESDIR" --template "$file" --stdin > "$REPOROOT/${filename%.tera}"
done
