#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0 <platform> <kick script name>

Provisioner's facade script
__EOT__
}

if [ $# -lt 2 ]
then
  echo "2 arguements is required."
  exit 1
fi
PLATFORM=${1}
SCRIPT=${2}
shift 2

case ${PLATFORM} in
  centos*|fedora*)
    rpm -ql git > /dev/null
    if [ $? -ne 0 ]
    then
      yum -y install git
    fi
    ;;
  debian*|ubuntu*)
    dpkg -l git > /dev/null
    if [ $? -ne 0 ]
    then
      apt-get -y install git
    fi
    ;;
  *)
    echo "platform ${PLATFORM} is invalid"
    exit 1
    ;;
esac

WORKDIR=~/work
if [ ! -d ${WORKDIR} ]
then
  mkdir ${WORKDIR}
fi
cd ${WORKDIR}

REPOS_NAME=provisioning-bash
if [ ! -d ${REPOS_NAME} ]
then
  git clone https://github.com/goldeneggg/${REPOS_NAME}.git
fi
cd ${REPOS_NAME}
git pull --rebase origin master
cd ${PLATFORM}

LOGDIR=logs
if [ ! -d ${LOGDIR} ]
then
  mkdir ${LOGDIR}
fi
bash ${SCRIPT} $@ 2>&1 | tee ${LOGDIR}/${SCRIPT}.log
