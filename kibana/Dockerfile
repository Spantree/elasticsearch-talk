FROM kibana:4.6

MAINTAINER Spantree Technology Group, LLC <devops@spantree.net>

RUN kibana plugin -i elastic/sense \
 && kibana plugin -i elasticsearch/marvel/latest \
 && kibana plugin -i elastic/timelion \
 && kibana plugin -i logtrail -u https://github.com/sivasamyk/logtrail/releases/download/0.1.7/logtrail-4.x-0.1.7.tar.gz
