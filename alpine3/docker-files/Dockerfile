FROM alpine:3.10

MAINTAINER goldeneggg

RUN mkdir /tmp/prv-bash
WORKDIR /tmp/prv-bash

ADD https://git.io/prv-bash /tmp/prv-bash/entry.sh

RUN apk update && \
  apk add bash && \
  apk add tzdata && \
  bash entry.sh alpine3 init.sh
