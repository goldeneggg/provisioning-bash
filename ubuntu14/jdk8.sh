#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || (echo "${MYUSER} can not run ${MYNAME}"; exit 1)

# args
## 1 = jdk version
declare -r JDK_VER=${1:-"8"}
declare -r JDK_MINER_VER=${2:-"45"}
declare -r JDK_BETA_VER=${3:-"b14"}
echo "jdk version = ${JDK_VER}-${JDK_MINER_VER}-${JDK_BETA_VER}"

: "----- install jdk"
declare -r JDK_ARCHIVE=jdk-${JDK_VER}u${JDK_MINER_VER}-linux-x64.tar.gz
${PRVENV_WGETCMD} --no-cookies - --header "Cookie: oraclelicense=accept-securebackup-cookie"  https://edelivery.oracle.com/otn-pub/java/jdk/${JDK_VER}u${JDK_MINER_VER}-${JDK_BETA_VER}/${JDK_ARCHIVE}

declare -r JDK_PREFIX=/usr/local
tar -C ${JDK_PREFIX} -zxf ${JDK_ARCHIVE}
ln -s ${JDK_PREFIX}/jdk1.${JDK_VER}.0_${JDK_MINER_VER} ${JDK_PREFIX}/jdk

export JAVA_HOME=${JDK_PREFIX}/jdk
echo "export JAVA_HOME=${JAVA_HOME}" >> ${ENV_RC}
echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> ${ENV_RC}
source ${ENV_RC}

which java
java -version
