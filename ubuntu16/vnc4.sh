#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- install vnc4server"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} xfce4 xfce4-goodies vnc4server

: "----- evacuate original xstartup file"
declare -r XSTARTUP_DIR=/root/.vnc
declare -r XSTARTUP_FILE=/root/.vnc/xstartup
if [ -f ${XSTARTUP_FILE} ]
then
  mv ${XSTARTUP_FILE} ${XSTARTUP_FILE}.bak
elif [ ! -d ${XSTARTUP_DIR} ]
then
  mkdir -p ${XSTARTUP_DIR}
fi

: "----- copy customize files"
declare -r COPY_TARGETS=(${XSTARTUP_FILE})
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

: "----- finish message"
echo "vnc4server初回起動にてパスワードを設定し、インストールを完了してください"
