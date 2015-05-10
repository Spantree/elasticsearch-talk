#!/bin/bash

set -e

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