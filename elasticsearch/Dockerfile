FROM elasticsearch:2.4.5

MAINTAINER Spantree Technology Group <devops@spantree.net>

# Install Marvel (and Sense)
RUN plugin install license \
  && plugin install -b marvel-agent \
  && plugin install lmenezes/elasticsearch-kopf \
  && plugin install polyfractal/elasticsearch-inquisitor \
  && plugin install https://github.com/NLPchina/elasticsearch-sql/releases/download/2.4.5.0/elasticsearch-sql-2.4.5.0.zip

# Add configuration folders and files onto system
COPY config /usr/share/elasticsearch/config
