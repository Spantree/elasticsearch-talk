FROM spantree/docker-elasticsearch-no-volume:1.5.2

MAINTAINER Spantree Technology Group <devops@spantree.net>

RUN apt-get update \
	&& apt-get install -y httpie \
	&& rm -rf /var/lib/apt/lists/*

### End Section

# Install Marvel (and Sense)
RUN plugin -i elasticsearch/marvel/latest \
  && plugin -i lmenezes/elasticsearch-kopf \
  && plugin -i polyfractal/elasticsearch-inquisitor \
  && plugin -u https://github.com/NLPchina/elasticsearch-sql/releases/download/1.3.2/elasticsearch-sql-1.3.2.zip --install sql

# Add configuration folders and files onto system
COPY config /usr/share/elasticsearch/config
COPY etc/default/elasticsearch /etc/default/elasticsearch
COPY sense/app/spantree.senseEditorReplace.js /usr/share/elasticsearch/plugins/marvel/_site/sense/app/spantree.senseEditorReplace.js

# Inject our custom Sense editor tutorial script (to preload examples based on URL hash)
RUN sed -i -e 's|</body>|<script src="app/spantree.senseEditorReplace.js"></script></body>|'  /usr/share/elasticsearch/plugins/marvel/_site/sense/index.html

# Add our sample data sets
ADD data /tmp/data

WORKDIR /tmp/data

# Create the mappings and index the data for our sample data sets
RUN /tmp/data/index.sh

# Add a list minute fix for entrypoint permissions on the CCC VM
RUN chmod u+x /docker-entrypoint.sh

WORKDIR /data
