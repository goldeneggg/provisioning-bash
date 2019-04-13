#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- download erlang"
declare -r MAJOR_VER=${1:-"1.34"}
declare -r MINOR_VER=${2:-"0"}

declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=rust-${VER}-x86_64-unknown-linux-gnu.tar.gz

pushd ${PRVENV_INSTALL_WORK_DIR}
[ -f ${TAR} ] && rm -f ${TAR}

${PRVENV_WGETCMD} https://static.rust-lang.org/dist/${TAR}

declare -r SRCDIR=${TAR//.tar.gz/}
[ -d ${SRCDIR} ] && rm -fr ${SRCDIR}
tar zxf ${TAR}

: "----- install"
pushd ${SRCDIR}

sh install.sh
