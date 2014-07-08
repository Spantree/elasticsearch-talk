#!/bin/bash

ES_INDEX_URL="http://192.168.80.100:9200/divvy"

echo "Inserting mappings"
curl -f -s -S -XPOST --data-binary "@mappings/divvy_mappings.json" "$ES_INDEX_URL"

echo "Setting refresh_interval = -1"
curl -f -s -S -XPUT "$ES_INDEX_URL/_settings" -d '{"index": {"refresh_interval": "-1"}}'

echo "Bulk loading data"
curl -f -s -S -XPOST --data-binary "@bulk/divvy_bulk_update.json" "$ES_INDEX_URL/_bulk"

echo "Setting refresh_interval = 1s"
curl -f -s -S -XPUT "$ES_INDEX_URL/_settings" -d '{"index": {"refresh_interval": "1s"}}'
