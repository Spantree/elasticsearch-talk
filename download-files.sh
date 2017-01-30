#!/usr/bin/env bash

set -o xtrace  # trace what gets executed
set -o errexit # exit when a command fails.
set -o nounset # exit when your script tries to use undeclared variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GZ_URLS="\
  https://s3.amazonaws.com/elasticsearch-sample-data/enron_messages.jsonl.gz \
  http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz \
"

NORMAL_URLS="\
  https://raw.githubusercontent.com/elastic/examples/master/ElasticStack_apache/apache_logs \
  https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD
  https://raw.githubusercontent.com/elastic/examples/master/ElasticStack_nyc_traffic_accidents/nyc_collision_logstash.conf \
  https://raw.githubusercontent.com/elastic/examples/master/ElasticStack_nyc_traffic_accidents/nyc_collision_template.json \
  https://raw.githubusercontent.com/elastic/examples/master/ElasticStack_nyc_traffic_accidents/nyc_collision_kibana.json \
"

mkdir -p data
cd data

for url in $GZ_URLS; do
  filename=$(basename $url)
  filename="${filename/.gz/}"
  if [ ! -f $filename ]; then
    curl -L $url | gunzip > $filename
  fi
done

for url in $NORMAL_URLS; do
  filename=$(basename $url)
  if [ ! -f $filename ]; then
    wget $url
  fi
done

cd $__dir
