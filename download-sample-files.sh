#!/usr/bin/env bash

set -o xtrace  # trace what gets executed
set -o errexit # exit when a command fails.
set -o nounset # exit when your script tries to use undeclared variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GZ_URLS="\
  https://s3.amazonaws.com/elasticsearch-sample-data/enron_messages.jsonl.gz \
  http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz \
"

NORMAL_URLS="\
  https://github.com/elastic/examples/raw/master/Common%20Data%20Formats/apache_logs/apache_logs \
  https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD
  https://raw.githubusercontent.com/elastic/examples/master/Exploring%20Public%20Datasets/nyc_traffic_accidents/nyc_collision_logstash.conf \
  https://raw.githubusercontent.com/elastic/examples/master/Exploring%20Public%20Datasets/nyc_traffic_accidents/nyc_collision_template.json \
  https://raw.githubusercontent.com/elastic/examples/master/Exploring%20Public%20Datasets/nyc_traffic_accidents/nyc_collision_kibana.json \
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
