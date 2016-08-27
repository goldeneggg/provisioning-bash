#!/bin/bash

set -ux

function usage {
    cat << __EOT__
Usage: $0 <platform> <kick script name> [other args]

Provisioner's facade script
__EOT__
}

(( $# < 2 )) && { echo "2 arguements is required."; exit 1; }

declare -r PLATFORM=${1}
declare -r SCRIPT=${2}
shift 2

: "----- install git"
case ${PLATFORM} in
  centos*|fedora*|amazon*)
    : "----- platform is rhel family"
    rpm -ql git > /dev/null
    (( $? )) && yum -y install git
    ;;
  debian*|ubuntu*)
    : "----- platform is debian family"
    dpkg -l | grep " git " > /dev/null
    (( $? )) && apt-get -y install git
    ;;
  *)
    echo "platform ${PLATFORM} is invalid"
    exit 1
    ;;
esac

declare -r WORKDIR=${HOME}/work
[ -d ${WORKDIR} ] || mkdir ${WORKDIR}
pushd ${WORKDIR}

declare -r REPOS_NAME=provisioning-bash
[ -d ${REPOS_NAME} ] || git clone https://github.com/goldeneggg/${REPOS_NAME}.git

pushd ${REPOS_NAME}
git pull --rebase origin master
pushd ${PLATFORM}

declare -r LOGDIR=logs
[ -d ${LOGDIR} ] || mkdir ${LOGDIR}

: "----- execute provisioning script"
bash ${SCRIPT} $@ 2>&1 | tee ${LOGDIR}/${SCRIPT}.log
