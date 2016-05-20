#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- download lua"
declare -r MAJOR_VER=${1:-"5.3"}
declare -r MINOR_VER=${2:-"2"}

declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=lua-${VER}.tar.gz

[ -f ${TAR} ] && rm -f ${TAR}

curl -R -O http://www.lua.org/ftp/${TAR}

declare -r SRCDIR=lua-${VER}
[ -d ${SRCDIR} ] && rm -fr ${SRCDIR}
tar zxf ${TAR}

: "----- test lua"
pushd ${SRCDIR}
make linux test

: "----- install lua"
make install
