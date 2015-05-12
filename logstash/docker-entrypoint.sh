#!/bin/bash

set -e

ES_HEAP_SIZE=${ES_HEAP_SIZE?"1g"}
echo "ES_HEAP_SIZE=${ES_HEAP_SIZE}" > /etc/default/elasticsearch

service elasticsearch start

# Add logstash as command if needed
if [[ "$1" == -* ]]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" == logstash ]; then
	set -- gosu logstash "$@"
fi

exec "$@"