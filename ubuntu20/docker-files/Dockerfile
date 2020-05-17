FROM ubuntu:20.04

MAINTAINER goldeneggg

RUN mkdir /tmp/prv-bash
WORKDIR /tmp/prv-bash

ADD https://git.io/prv-bash /tmp/prv-bash/entry.sh

RUN bash entry.sh ubuntu20 init.sh
