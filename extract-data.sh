#!/usr/bin/env bash

set -o errexit # exit when a command fails
set -o pipefail # exit if pipe fails
set -o nounset # exit when script tries to use undeclared variables

ES_HOST="http://localhost:9201"
OUTPUT_DIR=".data"
SCROLL_TIME="1m"
BATCH_SIZE=1000

# Make sure output directory exists
mkdir -p "$OUTPUT_DIR"

# Get list of indices
INDICES=$(curl -s "${ES_HOST}/_cat/indices?h=index" | grep -v "freebase" | tr -d ' ')

for INDEX in $INDICES; do
  echo "Extracting data from index: $INDEX"
  OUTPUT_FILE="${OUTPUT_DIR}/${INDEX}.jsonl"
  
  # Initialize the scroll
  SCROLL_ID=$(curl -s -X POST "${ES_HOST}/${INDEX}/_search?scroll=${SCROLL_TIME}" -d '{
    "size": '${BATCH_SIZE}',
    "sort": ["_doc"],
    "query": {"match_all": {}}
  }' | jq -r '._scroll_id')
  
  # Get the first batch of results
  RESULTS=$(curl -s -X POST "${ES_HOST}/_search/scroll" -d '{
    "scroll": "'${SCROLL_TIME}'",
    "scroll_id": "'${SCROLL_ID}'"
  }')
  
  # Extract hits
  echo "$RESULTS" | jq -c '.hits.hits[]._source' > "$OUTPUT_FILE"
  
  # Continue scrolling until no more hits
  TOTAL_HITS=$(echo "$RESULTS" | jq '.hits.total')
  HITS_COUNT=$(echo "$RESULTS" | jq '.hits.hits | length')
  
  while [ "$HITS_COUNT" -gt 0 ]; do
    echo "Processed $HITS_COUNT documents from $INDEX..."
    
    # Get the next batch of results
    RESULTS=$(curl -s -X POST "${ES_HOST}/_search/scroll" -d '{
      "scroll": "'${SCROLL_TIME}'",
      "scroll_id": "'${SCROLL_ID}'"
    }')
    
    # Extract hits and append to file
    echo "$RESULTS" | jq -c '.hits.hits[]._source' >> "$OUTPUT_FILE"
    
    # Update scroll ID and counts
    SCROLL_ID=$(echo "$RESULTS" | jq -r '._scroll_id')
    HITS_COUNT=$(echo "$RESULTS" | jq '.hits.hits | length')
  done
  
  # Clean up the scroll
  curl -s -X DELETE "${ES_HOST}/_search/scroll" -d '{
    "scroll_id": ["'${SCROLL_ID}'"]
  }' > /dev/null
  
  echo "Completed extracting data from $INDEX"
  echo "Data saved to $OUTPUT_FILE"
  echo
done

echo "All data extraction complete!" 