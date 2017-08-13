#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

declare -r MAJOR_VER=${1:-"4.4"}
declare -r MINOR_VER=${2:-"0"}
declare -r ANACONDA3_VER=${MAJOR_VER}.${MINOR_VER}

declare -r ANACONDA3_SCRIPT=Anaconda3-${ANACONDA3_VER}-Linux-x86_64.sh

: "----- download anaconda3"
${PRVENV_WGETCMD} https://repo.continuum.io/archive/${ANACONDA3_SCRIPT}

: "----- install anaconda3"
declare -r ANACONDA3_ROOT=${HOME}/anaconda3
bash ${ANACONDA3_SCRIPT} -b -f -p ${ANACONDA3_ROOT}

: "----- set python3 environments"
echo "export ANACONDA3_ROOT=${ANACONDA3_ROOT}" >> ${ENV_RC}
echo 'export PATH=${ANACONDA3_ROOT}/bin:$PATH' >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u
