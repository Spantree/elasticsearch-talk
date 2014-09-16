#!/bin/bash
cd /usr/src/elasticsearch-talk/transform
groovy -cp "lib/*" src/main/groovy/net/spantree/elasticsearch/talk/TransformExamples.groovy
cd www
sudo cp -f * /var/www/