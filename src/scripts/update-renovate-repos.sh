#!/usr/bin/env bash

readonly BASEDIR="$(dirname -- "$0")"
readonly REPOROOT="$(realpath "$BASEDIR/../..")"
readonly SCHEMAS_DIR=$(realpath "$REPOROOT/src/schemas")
readonly RENOVATE_CONFIG="$(realpath "$REPOROOT/.github/renovate.json5")"

function renovate-repos {
   pushd "$SCHEMAS_DIR" >/dev/null 2>&1
   cue cmd build:renovate
   popd >/dev/null 2>&1
}

CONFIG="$(renovate-repos)"
HEAD="$(sed -n '1,/      \/\/ #### BEGIN Helm Chart repositories ####/ p' "$RENOVATE_CONFIG")"
TAIL="$(sed -n '/      \/\/ #### END Helm Chart repositories ####/,$ p' "$RENOVATE_CONFIG")"


NFILE="$HEAD"
NFILE+=$'\n'
NFILE+="$CONFIG"
NFILE+=$'\n'
NFILE+="$TAIL"

echo "$NFILE" > "$RENOVATE_CONFIG"
git add "$RENOVATE_CONFIG"
