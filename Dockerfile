FROM java:7-jre

MAINTAINER Spantree Technology Group <devops@spantree.net>

### Section: This part is based on the docker library Elasticsearch build
### (but we've removed the volumes so that data lives in the union file
###	system)

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV ELASTICSEARCH_VERSION 1.5.2

RUN echo "deb http://packages.elasticsearch.org/elasticsearch/${ELASTICSEARCH_VERSION%.*}/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

# piggybacked off of this command to install httpie, avoiding a second
# apt-get update
RUN apt-get update \
	&& apt-get install -y httpie elasticsearch=$ELASTICSEARCH_VERSION \
	&& rm -rf /var/lib/apt/lists/*

ENV PATH /usr/share/elasticsearch/bin:$PATH

### End Section

# Install Marvel (and Sense)
RUN plugin -i elasticsearch/marvel/latest

# Install Kopf (for node monitoring, etc)
RUN plugin -i lmenezes/elasticsearch-kopf

# Install Inquisitor (for visualizing the analyzer chain)
RUN plugin -i polyfractal/elasticsearch-inquisitor

# Install Elasticsearch SQL (in case we want to demo that too)
RUN plugin -u https://github.com/NLPchina/elasticsearch-sql/releases/download/1.3.2/elasticsearch-sql-1.3.2.zip --install sql

# Add configuration folders and files onto system
COPY containers/elasticsearch/config /usr/share/elasticsearch/config
COPY containers/elasticsearch/etc/default/elasticsearch /etc/default/elasticsearch
COPY containers/elasticsearch/sense/app/spantree.senseEditorReplace.js /usr/share/elasticsearch/plugins/marvel/_site/sense/app/spantree.senseEditorReplace.js

# Inject our custom Sense editor tutorial script (to preload examples based on URL hash)
RUN sed -i -e 's|</body>|<script src="spantree.senseEditorReplace.js"></script></body>|'  /usr/share/elasticsearch/plugins/marvel/_site/sense/index.html

# Add our sample data sets
ADD data /tmp/data

WORKDIR /tmp/data

# Create the mappings and index the data for our sample data sets
RUN /tmp/data/index.sh

COPY docker-entrypoint.sh /

WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300

CMD ["elasticsearch"]