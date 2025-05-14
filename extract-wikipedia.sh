#!/usr/bin/env bash

set -o errexit # exit when a command fails
set -o pipefail # exit if pipe fails
set -o nounset # exit when script tries to use undeclared variables

ES_HOST="http://localhost:9201"
OUTPUT_DIR=".data"
OUTPUT_FILE="${OUTPUT_DIR}/wikipedia.jsonl"

mkdir -p "$OUTPUT_DIR"

# Get all documents from the wikipedia index with a single query
curl -s -X GET "${ES_HOST}/wikipedia/_search?size=100" -d '{
  "query": {"match_all": {}}
}' | jq -c '.hits.hits[]._source' > "$OUTPUT_FILE"

echo "Data saved to $OUTPUT_FILE"
wc -l "$OUTPUT_FILE" 