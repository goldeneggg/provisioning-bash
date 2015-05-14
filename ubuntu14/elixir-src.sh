#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

bash ${MYDIR}/erlang-src.sh

: "----- download erlang"
declare -r MAJOR_VER=${1:-"1.0"}
declare -r MINOR_VER=${2:-"4"}

declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=v${VER}.tar.gz

declare -r PREFIX=/usr/local
pushd ${PREFIX}
[ -f ${TAR} ] && rm -f ${TAR}

${PRVENV_WGETCMD} https://github.com/elixir-lang/elixir/archive/${TAR}

declare -r SRCDIR=elixir-${VER}
[ -d ${SRCDIR} ] && rm -fr ${SRCDIR}
tar zxf ${TAR}

: "----- install elixir"
pushd ${SRCDIR}
make clean test

: "----- symlink versioning elixir to non-versioning elixir"
declare -r ELIXIR_HOME=/usr/local/elixir
[ -d ${ELIXIR_HOME} -o -L ${ELIXIR_HOME} ] && rm -fr ${ELIXIR_HOME}
ln -s ${SRCDIR} ${ELIXIR_HOME}

: "----- add elixir bin path into bashrc"
echo "export PATH=${ELIXIR_HOME}/bin"':$PATH' >> ${ENV_RC}
source ${ENV_RC}
