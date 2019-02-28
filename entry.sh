#!/bin/bash

set -ux

function usage {
    cat << __EOT__
Usage: $0 [Options] PLATFORM SCRIPT_NAME [OTHER ARGS...]

Provisioner's facade script

Options:
  -b | --branch          target branch
  -h | --help            print a summary of the options

__EOT__
}


declare BRANCH=master
while true; do
  case "$1" in
    -h | --help ) usage; exit 1 ;;
    -b | --branch ) BRANCH=$2; shift 2 ;;
    * ) break ;;
  esac
done

(( $# < 2 )) && { echo "2 arguements is required."; exit 1; }

declare -r PLATFORM=${1}
declare -r SCRIPT=${2}
shift 2

: "----- install git"
case ${PLATFORM} in
  centos*|fedora*|amazon*)
    : "----- platform is rhel family"
    rpm -ql git > /dev/null
    if [ $? -ne 0 ]
    then
      yum -y update
      yum -y install git
    fi
    ;;
  debian*|ubuntu*)
    : "----- platform is debian family"
    dpkg -l | grep " git " > /dev/null
    if [ $? -ne 0 ]
    then
      apt-get -y update
      apt-get -y --no-install-recommends install git ca-certificates
    fi
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
[ -d ${REPOS_NAME} ] || git clone https://github.com/goldeneggg/${REPOS_NAME}

pushd ${REPOS_NAME}
if [ ${BRANCH} != "master" ]
then
  git branch ${BRANCH} origin/${BRANCH}
  git checkout ${BRANCH}
fi

git pull --rebase origin ${BRANCH}
pushd ${PLATFORM}

declare -r LOGDIR=logs
[ -d ${LOGDIR} ] || mkdir ${LOGDIR}

: "----- execute provisioning script"
bash ${SCRIPT} $@ 2>&1 | tee ${LOGDIR}/${SCRIPT}.log
