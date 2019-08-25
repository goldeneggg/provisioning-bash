#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## 1 = jdk version
declare -r JDK_VER=${1:-"11.0.4"}
declare -r JDK_BETA_VER=${2:-"+10"}
echo "jdk version = ${JDK_VER}${JDK_BETA_VER}"


: "----- install jdk"
# https://download.oracle.com/otn/java/jdk/11.0.4+10/cf1bbcbf431a474eb9fc550051f4ee78/jdk-11.0.4_linux-x64_bin.tar.gz
pushd ${PRVENV_INSTALL_WORK_DIR}
declare -r JDK_ARCHIVE=jdk-${JDK_VER}_linux-x64_bin.tar.gz
declare -r PATH_HASH=cf1bbcbf431a474eb9fc550051f4ee78
${PRVENV_WGETCMD} --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn/java/jdk/${JDK_VER}${JDK_BETA_VER}/${PATH_HASH}/${JDK_ARCHIVE}

declare -r JDK_PREFIX=/usr/local
declare -r JAVA_HOME=${JDK_PREFIX}/java
tar -C ${JDK_PREFIX} -zxf ${JDK_ARCHIVE}
ln -s ${JDK_PREFIX}/jdk-${JDK_VER} ${JAVA_HOME}

export JAVA_HOME
echo "export JAVA_HOME=${JAVA_HOME}" >> ${ENV_RC}
echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u

which java
java -version
