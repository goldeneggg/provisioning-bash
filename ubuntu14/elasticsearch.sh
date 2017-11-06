#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- install dependency packages"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} apt-transport-https

: "----- add elasticsearch officlal GPG KEY"
declare -r FINGERPRINT=D88E42B4
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
# apt-key fingerprint ${FINGERPRINT}

: "----- add sources.list"
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list

: "----- install elasticsearch"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} elasticsearch

# See: https://www.elastic.co/guide/en/elasticsearch/reference/5.6/deb.html
