#!/usr/bin/env bash

set -o xtrace  # trace what gets executed
set -o errexit # exit when a command fails.
# set -o nounset # exit when your script tries to use undeclared variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ELASTICSEARCH_HTTP_PORT=9200

wait_for_port_open() {
  tries=0
  until [ $tries -ge 20 ]
  do
    nc localhost -z $1 && break
    tries=$[$tries+1]
    sleep 2
  done
}

service elasticsearch start

wait_for_port_open $ELASTICSEARCH_HTTP_PORT

# add our initial visualizations and dashboard
http POST "localhost:${ELASTICSEARCH_HTTP_PORT}/_bulk?refresh=true" "@/tmp/kibana/kibana-assets.json.bulk"

# wait until our assets have been indexed
result_count=0
until [ $result_count -ge 13 ]
do
  result_count=$[$(http "localhost:${ELASTICSEARCH_HTTP_PORT}/.kibana/_search?search_type=count" | jq '.hits.total')]
  sleep 2
done

service elasticsearch stop

