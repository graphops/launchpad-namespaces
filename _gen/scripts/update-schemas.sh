#!/usr/bin/env bash

readonly GENOPENAPI="$(dirname "$0")/generate-openapi.sh"
readonly SCHEMA_DIR="$(dirname "$0")/../.."

$GENOPENAPI > "$SCHEMA_DIR/schema.json"
