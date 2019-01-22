#!/bin/bash

# See: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## 1 = mongo version
declare -r MINOR_VER=${1:-"5"}
declare -r MAJOR_VER="4.0"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
echo "mongo version = ${VER}"

: "----- add mongo officlal GPG KEY"
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

: "----- add repository"
declare -r UBUNTU_VERNAME=bionic
cat <<EOF >/etc/apt/sources.list.d/mongodb-org-${MAJOR_VER}.list
deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu ${UBUNTU_VERNAME}/mongodb-org/${MAJOR_VER} multiverse
EOF

: "----- install mongo"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} mongodb-org=${VER} mongodb-org-server=${VER} mongodb-org-shell=${VER} mongodb-org-mongos=${VER} mongodb-org-tools=${VER}

: "----- restart mongod"
service mongod restart
