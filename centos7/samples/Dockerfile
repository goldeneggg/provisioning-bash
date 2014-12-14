FROM centos:centos7

MAINTAINER goldeneggg

RUN mkdir /tmp/init
WORKDIR /tmp/init

ADD https://raw.githubusercontent.com/goldeneggg/provisioning-scripts/master/facade.sh /tmp/init/facade.sh

RUN bash facade.sh centos7 cui.sh
