#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## 1 = jdk version
declare -r JDK_VER=${1:-"11.0.1"}
declare -r JDK_BETA_VER=${2:-"+13"}
echo "jdk version = ${JDK_VER}${JDK_BETA_VER}"

: "----- install jdk"
# https://download.oracle.com/otn-pub/java/jdk/11.0.1+13/90cf5d8f270a4347a95050320eef3fb7/jdk-11.0.1_linux-x64_bin.tar.gz
pushd ${PRVENV_INSTALL_WORK_DIR}
declare -r JDK_ARCHIVE=jdk-${JDK_VER}_linux-x64_bin.tar.gz
declare -r PATH_HASH=90cf5d8f270a4347a95050320eef3fb7
${PRVENV_WGETCMD} --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JDK_VER}${JDK_BETA_VER}/${PATH_HASH}/${JDK_ARCHIVE}

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
