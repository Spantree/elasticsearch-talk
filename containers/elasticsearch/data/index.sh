#!/usr/bin/env bash

set -o xtrace  # trace what gets executed
set -o errexit # exit when a command fails.
set -o nounset # exit when your script tries to use undeclared variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

service elasticsearch start
wget "http://localhost:9200" --retry-connrefused -T 60 > /dev/null 2>&1

TMP_DATA_DIR="${__dir}"
ES_URL="http://localhost:9200"
MAX_SPLIT_LINES=10000

create_index () {
	index=${1}
	data_file=${2}
	echo "Creating ${index} index"

	http --ignore-stdin POST "${ES_URL}/${index}" "@${TMP_DATA_DIR}/mappings/${data_file}.mappings.json"
	http --ignore-stdin PUT "${ES_URL}/${index}/_settings" "@${TMP_DATA_DIR}/payloads/stop-refresh.json"
	mkdir -p "${index}"
	cd "${index}"
	tar -xzvf "${TMP_DATA_DIR}/bulk/${data_file}.json.bulk.tar.gz"
	split -a 5 -l ${MAX_SPLIT_LINES} "${data_file}.json.bulk" "${data_file}.json.bulk."
	for f in `ls ${data_file}.json.bulk.*`
	do
		http  --ignore-stdin -h POST "${ES_URL}/${index}/_bulk" "@${f}"
	done
	http POST "${ES_URL}/${index}/_refresh"
	http POST "${ES_URL}/${index}/_optimize"

	http --ignore-stdin PUT "${ES_URL}/${index}/_settings" "@${TMP_DATA_DIR}/payloads/start-refresh.json"
}

create_index "wikipedia" "wikipedia.locations"
create_index "divvy" "divvy"
create_index "freebase" "films"

http --ignore-stdin DELETE "${ES_URL}/freebase/films/_query" "@${TMP_DATA_DIR}/payloads/delete-inappropriate-films.json"

service elasticsearch stop