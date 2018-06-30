#!/bin/bash

# See: https://kubernetes.io/docs/tasks/tools/install-kubeadm/
# See: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- swapoff"
# See: https://github.com/kubernetes/kubernetes/issues/7294
swapoff -a

: "----- configure cgroup driver"
#docker info | grep -i cgroup
#cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
#sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

${PRVENV_CMD_INIT_RELOAD}
${PRVENV_CMD_INIT_RESTART} kubelet

: "----- initialize kubernetes master"
declare -r POD_CIDR=10.244.0.0/16
MY_INTF=enp0s8
MY_IP=$(ip addr show ${MY_INTF} | grep -Po 'inet \K[\d.]+')
kubeadm init --pod-network-cidr=${POD_CIDR} --apiserver-advertise-address=${MY_IP}
#kubeadm init --pod-network-cidr=${POD_CIDR}

: "----- create $HOME/.kube/config to start using your cluster"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

: "----- install pod network addon (flannel)"
declare -r POD_NETWORK_YAML=https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
kubectl apply -f ${POD_NETWORK_YAML}
kubectl get pods --all-namespaces

 # Note: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#instructions

: "----- be able to schedule pods on the master"
kubectl taint nodes --all node-role.kubernetes.io/master-
