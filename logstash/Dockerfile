FROM spantree/docker-elasticsearch-no-volume:1.5.2

MAINTAINER Spantree Technology Group <devops@spantree.net>

ENV LOGSTASH_MAJOR 1.4
ENV LOGSTASH_VERSION 1.4.2-1-2c0f5a1

RUN plugin -i lmenezes/elasticsearch-kopf

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

RUN echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | tee /etc/apt/sources.list.d/logstash.list \
  && wget -q -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - \
  && apt-get update \
  && apt-get install -y --no-install-recommends netcat jq pv httpie logstash=$LOGSTASH_VERSION unzip \
  && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/logstash/bin:$PATH

WORKDIR /usr/local/share/geoip

RUN wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz \
  && gunzip GeoLiteCity.dat.gz

WORKDIR /tmp

RUN wget -q http://spantree.s3.amazonaws.com/star_wars_kid.log.gz

COPY etc/logstash /etc/logstash

WORKDIR /data
RUN chown logstash:logstash /data

ADD ./send-log.sh /tmp/send-log.sh

RUN /tmp/send-log.sh

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["logstash"]