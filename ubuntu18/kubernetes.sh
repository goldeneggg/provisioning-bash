#!/bin/bash

# See: https://kubernetes.io/docs/tasks/tools/install-kubeadm/

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- install dependency packages"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} apt-transport-https

: "----- add kubernetes officlal GPG KEY"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

: "----- add repository"
# Note: まだbionic版が提供されていないのでxenialにしている
declare -r UBUNTU_VERNAME=xenial
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-${UBUNTU_VERNAME} main
EOF

: "----- install kubernetes"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} kubelet kubeadm kubectl
