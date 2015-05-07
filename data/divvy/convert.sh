#!/bin/bash

rm trips.in
tar xzvf "trips.in.tar.gz"
python convert.py > divvy.json.bulk
rm divvy.json.bulk.tar.gz
tar czvf divvy.json.bulk.tar.gz divvy.json.bulk
rm ../bulk/divvy.json.bulk.tar.gz
mv divvy.json.bulk.tar.gz ../bulk