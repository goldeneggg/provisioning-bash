#!/bin/bash

# See: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## 1 = mongo version
declare -r MINOR_VER=${1:-"0"}
declare -r MAJOR_VER="4.2"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
echo "mongo version = ${VER}"

: "----- add mongo officlal GPG KEY"
wget -qO - https://www.mongodb.org/static/pgp/server-${MAJOR_VER}.asc | apt-key add -

: "----- add repository"
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/${MAJOR_VER} multiverse" | tee /etc/apt/sources.list.d/mongodb-org-${MAJOR_VER}.list

: "----- install mongo"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} mongodb-org=${VER} mongodb-org-server=${VER} mongodb-org-shell=${VER} mongodb-org-mongos=${VER} mongodb-org-tools=${VER}

: "----- restart mongod"
service mongod restart

