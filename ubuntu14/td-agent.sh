#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh

/etc/init.d/td-agent start
