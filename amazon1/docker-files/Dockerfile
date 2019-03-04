FROM amazonlinux:1

MAINTAINER goldeneggg

RUN mkdir /tmp/prv-bash
WORKDIR /tmp/prv-bash

ADD https://git.io/prv-bash /tmp/prv-bash/entry.sh

RUN bash entry.sh amazon1 init.sh
