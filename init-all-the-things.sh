#!/usr/bin/env bash

set -o errexit # exit when a command fails.
set -o nounset # exit when your script tries to use undeclared variables

wait_for_http_port() {
  port=$1
  while ! curl --output /dev/null --silent --head --fail http://localhost:$port; do
    sleep 5
    echo -n Waiting for port $port to be open, sleeping 5 seconds.
  done
}

# Pull all the necessary Docker containers
docker-compose pull
# Build the customized docker containers (installing plugins, etc)
docker-compose build --pull

# Bring up the containers that need to be initialized with
# dependencies or data
docker-compose up -d elastic1 elastic2 elastic3 slides

# Wait for Elasticsearch cluster to be available
for port in "9200 9201 9202"; do
  wait_for_http_port $port
done

# Restore sample data snapshots
./load-sample-snapshots.sh

# Wait for slides to also be listening
wait_for_http_port 9000

# Stop all the services we brought up earlier
docker-compose stop

# Download all the sample data we will play around with
./load-sample-data.sh
