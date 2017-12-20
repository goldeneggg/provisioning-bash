#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -eu

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## 1 = go version
declare -r INNOTOP_VERSION=${1:-"1.9.1"}
echo "innotop version = ${INNOTOP_VERSION}"

: "----- install dependency cpan modules"
curl -L http://cpanmin.us | perl - App::cpanminus
declare -ar MODULES=('DBI' 'Time::HiRes' 'Term::ReadKey' 'DBD::mysql')
for m in ${MODULES[@]}
do
  cpanm ${m}
done

: "----- download innotop"
declare -r INNOTOP_PREFIX=/usr/local

pushd ${PRVENV_INSTALL_WORK_DIR}
${PRVENV_WGETCMD} https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/innotop/innotop-${INNOTOP_VERSION}.tar.gz
tar -zxf innotop-${INNOTOP_VERSION}.tar.gz
rm innotop-${INNOTOP_VERSION}.tar.gz

: "----- install innotop"
pushd innotop-${INNOTOP_VERSION}
perl Makefile.PL
make
make install
