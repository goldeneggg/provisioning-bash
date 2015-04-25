#!/bin/bash

set -ux

function usage {
    cat << __EOT__
Usage: $0 <platform> <kick script name>

Provisioner's facade script
__EOT__
}

if (( $# < 2 ))
then
  echo "2 arguements is required."
  exit 1
fi

declare -r PLATFORM=${1}
declare -r SCRIPT=${2}
shift 2

: "----- install git"
case ${PLATFORM} in
  centos*|fedora*|amazon*)
    : "----- platform is rhel family"
    rpm -ql git > /dev/null
    if (( $? ))
    then
      yum -y install git
    fi
    ;;
  debian*|ubuntu*)
    : "----- platform is debian family"
    dpkg -l git > /dev/null
    if (( $? ))
    then
      apt-get -y install git
    fi
    ;;
  *)
    echo "platform ${PLATFORM} is invalid"
    exit 1
    ;;
esac

declare -r WORKDIR=~/work
if [ ! -d ${WORKDIR} ]
then
  mkdir ${WORKDIR}
fi
pushd ${WORKDIR}

declare -r REPOS_NAME=provisioning-bash
if [ ! -d ${REPOS_NAME} ]
then
  git clone https://github.com/goldeneggg/${REPOS_NAME}.git
fi

pushd ${REPOS_NAME}
git pull --rebase origin master
pushd ${PLATFORM}

declare -r LOGDIR=logs
if [ ! -d ${LOGDIR} ]
then
  mkdir ${LOGDIR}
fi

: "----- execute provisioning script"
bash ${SCRIPT} $@ 2>&1 | tee ${LOGDIR}/${SCRIPT}.log
