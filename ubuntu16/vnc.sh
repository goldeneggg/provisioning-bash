#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- install tightvncserver"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} xfce4 xfce4-goodies tightvncserver

: "----- evacuate original xstartup file"
declare -r XSTARTUP_FILE=/root/.vnc/xstartup
mv ${XSTARTUP_FILE} ${XSTARTUP_FILE}.bak

: "----- copy customize files"
declare -r SERVICE_FILE=vncserver
declare -r INIT_SCRIPT=/etc/init.d/${SERVICE_FILE}

declare -r COPY_TARGETS=(${XSTARTUP_FILE} ${INIT_SCRIPT})
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

chmod +x ${INIT_SCRIPT}

: "----- finish message"
echo "vncserver初回起動にてパスワードを設定し、インストールを完了してください"
