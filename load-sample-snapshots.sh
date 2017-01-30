#!/usr/bin/env bash

set -o xtrace  # trace what gets executed
set -o errexit # exit when a command fails.
set -o nounset # exit when your script tries to use undeclared variables

REPOSITORY_NAME=sample_readonly

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create a read-only snapshot repository to pull files from S3 bucket via HTTPs
curl -X PUT -d '{"type": "url", "settings": {"url": "https://elasticsearch-sample-data.s3.amazonaws.com/"}}' "http://localhost:9200/_snapshot/${REPOSITORY_NAME}"

# Delete any existing indices
curl -X DELETE "http://localhost:9200/*"

# Read snapshots to restore from manifest file
for SNAPSHOT_NAME in $(cat ./snapshot-manifest); do
  # Restore snapshots with one replica
  time curl -X POST -d '{"index_settings": {"index.number_of_replicas": 1}}' "http://localhost:9200/_snapshot/${REPOSITORY_NAME}/${SNAPSHOT_NAME}/_restore?wait_for_completion=true"
done
