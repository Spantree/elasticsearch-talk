FROM nginx:latest

MAINTAINER Spantree Technology Group <devops@spantree.net>

ENV LANG C.UTF-8
ENV REVEAL_VERSION 2.6.2
ENV MATHJAX_VERSION 2.5.3

ENV CA_CERTIFICATES_JAVA_VERSION 20140324

RUN apt-get update \
	&& apt-get install -y -q wget nodejs npm nodejs-legacy openjdk-7-jdk ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
	&& rm -rf /var/lib/apt/lists/*

RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

WORKDIR /tmp/revealjs

RUN wget -q https://github.com/hakimel/reveal.js/archive/$REVEAL_VERSION.tar.gz \
    && tar xzf $REVEAL_VERSION.tar.gz \
    && rm $REVEAL_VERSION.tar.gz \
    && mv reveal.js-$REVEAL_VERSION /usr/share/nginx/html/slides

ADD nginx/default.conf /etc/nginx/conf.d/default.conf

ADD transform /usr/local/src/transform
ADD examples /usr/local/src/examples

WORKDIR /usr/local/src/transform
RUN /usr/local/src/transform/gradlew transform -Parguments="-e /usr/local/src/examples -o /usr/share/nginx/html"

WORKDIR /tmp/mathjax

RUN wget -q http://github.com/mathjax/MathJax/archive/$MATHJAX_VERSION.tar.gz \
  && tar xzf $MATHJAX_VERSION.tar.gz \
  && rm $MATHJAX_VERSION.tar.gz \
  && mv MathJax-$MATHJAX_VERSION /usr/local/src/

WORKDIR /usr/share/nginx/html/slides

RUN npm install -g grunt-cli \
  && npm install \
  && sed -i Gruntfile.js -e 's/port: port,/port: port, hostname: "",/'

ADD slides/js/ /usr/share/nginx/html/slides/js
RUN ln -sf /usr/local/src/MathJax-$MATHJAX_VERSION /usr/share/nginx/html/slides/js/MathJax

ADD slides/index.html /usr/share/nginx/html/slides/index.html
ADD slides/css/ /usr/share/nginx/html/slides/css
ADD slides/custom_css/ /usr/share/nginx/html/slides/custom_css
ADD slides/images/ /usr/share/nginx/html/slides/images
ADD slides/lib/ /usr/share/nginx/html/slides/lib
ADD slides/plugin/ /usr/share/nginx/html/slides/plugin
ADD slides/sections/ /usr/share/nginx/html/slides/sections