#!/usr/bin/env bash

set -o xtrace  # trace what gets executed
set -o errexit # exit when a command fails.
# set -o nounset # exit when your script tries to use undeclared variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOGSTASH_TCP_PORT=3333
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
service logstash start

wait_for_port_open $LOGSTASH_TCP_PORT
wait_for_port_open $ELASTICSEARCH_HTTP_PORT

cat /var/log/logstash/logstash.stdout

# Download and decompress the star wars kid log files and pipe to logstash tcp
gunzip /tmp/star_wars_kid.log.gz
pv -fber /tmp/star_wars_kid.log | nc -q 0 localhost $LOGSTASH_TCP_PORT
rm /tmp/star_wars_kid.log

# Also pipe a random string into logstash tcp
RANDOM_STRING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
cat << EOF | nc -q 0 localhost $LOGSTASH_TCP_PORT
$RANDOM_STRING
EOF

# wait until the random string is indexed and available
result_count=0
until [ $result_count -ge 1 ]
do
  result_count=$[$(http "localhost:${ELASTICSEARCH_HTTP_PORT}/_search?search_type=count&q=message:${RANDOM_STRING}" | jq '.hits.total')]
  sleep 2
done

service logstash stop
service elasticsearch stop

