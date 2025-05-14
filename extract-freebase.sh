#!/usr/bin/env bash

set -o errexit # exit when a command fails
set -o pipefail # exit if pipe fails
set -o nounset # exit when script tries to use undeclared variables

ES_HOST="http://localhost:9201"
OUTPUT_DIR=".data"
OUTPUT_FILE="${OUTPUT_DIR}/freebase.jsonl"
SCROLL_TIME="1m"
BATCH_SIZE=1000
MAX_ATTEMPTS=5

mkdir -p "$OUTPUT_DIR"

# Function to check if we got valid JSON response
function is_valid_json() {
  if echo "$1" | jq -e . >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

echo "Attempting to extract data from freebase index..."

# Try to get a count of documents
COUNT_RESPONSE=$(curl -s "${ES_HOST}/freebase/_count")
if is_valid_json "$COUNT_RESPONSE" && [[ $(echo "$COUNT_RESPONSE" | jq -r '.count // 0') -gt 0 ]]; then
  DOC_COUNT=$(echo "$COUNT_RESPONSE" | jq -r '.count')
  echo "Found $DOC_COUNT documents in freebase index"
else
  echo "Warning: Unable to get document count. Will attempt extraction anyway."
fi

# Try to get some data
for attempt in $(seq 1 $MAX_ATTEMPTS); do
  echo "Attempt $attempt of $MAX_ATTEMPTS to extract data..."
  
  # Try to get a small batch of data
  RESPONSE=$(curl -s "${ES_HOST}/freebase/_search?size=10" -d '{
    "query": {"match_all": {}},
    "sort": ["_doc"]
  }')
  
  if is_valid_json "$RESPONSE" && [[ $(echo "$RESPONSE" | jq -r '.hits.hits | length') -gt 0 ]]; then
    echo "Successfully retrieved documents. Starting full extraction..."
    break
  fi
  
  echo "No data found or encountered an error. Waiting 5 seconds before retrying..."
  sleep 5
  
  if [[ $attempt -eq $MAX_ATTEMPTS ]]; then
    echo "Failed to extract data after $MAX_ATTEMPTS attempts."
    echo "The index may still be initializing or is empty."
    exit 1
  fi
done

# Initialize output file
> "$OUTPUT_FILE"

# Initialize the scroll
echo "Initializing scroll for bulk extraction..."
SCROLL_RESPONSE=$(curl -s -X POST "${ES_HOST}/freebase/_search?scroll=${SCROLL_TIME}&ignore_unavailable=true" -d '{
  "size": '${BATCH_SIZE}',
  "sort": ["_doc"],
  "query": {"match_all": {}}
}')

if ! is_valid_json "$SCROLL_RESPONSE"; then
  echo "Error: Invalid response from Elasticsearch."
  echo "Response: $SCROLL_RESPONSE"
  exit 1
fi

# Check if we got any hits at all
HITS_COUNT=$(echo "$SCROLL_RESPONSE" | jq '.hits.hits | length')
if [[ $HITS_COUNT -eq 0 ]]; then
  echo "No documents found in the freebase index."
  exit 0
fi

# Extract hits
echo "$SCROLL_RESPONSE" | jq -c '.hits.hits[]._source' >> "$OUTPUT_FILE"
SCROLL_ID=$(echo "$SCROLL_RESPONSE" | jq -r '._scroll_id')

# Continue scrolling until no more hits
TOTAL_EXTRACTED=0
EXTRACTED_THIS_BATCH=$HITS_COUNT
((TOTAL_EXTRACTED += EXTRACTED_THIS_BATCH))

echo "Extracted $EXTRACTED_THIS_BATCH documents. Continuing..."

while [[ $EXTRACTED_THIS_BATCH -gt 0 ]]; do
  # Get the next batch of results
  SCROLL_RESPONSE=$(curl -s -X POST "${ES_HOST}/_search/scroll" -d '{
    "scroll": "'${SCROLL_TIME}'",
    "scroll_id": "'${SCROLL_ID}'"
  }')
  
  if ! is_valid_json "$SCROLL_RESPONSE"; then
    echo "Error: Invalid response from scroll request."
    break
  fi
  
  # Extract hits and append to file
  EXTRACTED_THIS_BATCH=$(echo "$SCROLL_RESPONSE" | jq '.hits.hits | length')
  
  if [[ $EXTRACTED_THIS_BATCH -gt 0 ]]; then
    echo "$SCROLL_RESPONSE" | jq -c '.hits.hits[]._source' >> "$OUTPUT_FILE"
    SCROLL_ID=$(echo "$SCROLL_RESPONSE" | jq -r '._scroll_id')
    ((TOTAL_EXTRACTED += EXTRACTED_THIS_BATCH))
    echo "Extracted $EXTRACTED_THIS_BATCH more documents. Total: $TOTAL_EXTRACTED"
  fi
done

# Clean up the scroll
curl -s -X DELETE "${ES_HOST}/_search/scroll" -d '{
  "scroll_id": ["'${SCROLL_ID}'"]
}' > /dev/null

# Check the file size
FILE_SIZE=$(wc -c < "$OUTPUT_FILE")
LINE_COUNT=$(wc -l < "$OUTPUT_FILE")

echo "Extraction completed."
echo "Extracted $TOTAL_EXTRACTED documents from freebase index."
echo "Output file size: $FILE_SIZE bytes"
echo "Line count: $LINE_COUNT"

# Compress the file
if [[ $FILE_SIZE -gt 0 ]]; then
  gzip -k "$OUTPUT_FILE"
  COMPRESSED_SIZE=$(wc -c < "${OUTPUT_FILE}.gz")
  echo "Compressed file size: $COMPRESSED_SIZE bytes"
  echo "Compression ratio: $(echo "scale=2; $COMPRESSED_SIZE * 100 / $FILE_SIZE" | bc)%"
else
  echo "Output file is empty. Skipping compression."
fi

echo "Extraction process complete." 