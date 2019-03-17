#!/bin/bash

set -ux

function usage {
    cat << __EOT__
Usage: $0 [Options] PLATFORM SCRIPT_NAME [OTHER ARGS...]

Provisioner's facade script

Options:
  -b | --branch          target branch
  --local                use local files(not clone from github.com)
  -h | --help            print a summary of the options

__EOT__
}

function install_git_centos() {
  yum -y update

  rpm -ql git > /dev/null
  if [ $? -ne 0 ]
  then
    : "----- install git"
    yum -y install git
  fi
}

function uninstall_git_centos() {
  : "----- uninstall git"
  yum -y remove git
}

function install_git_debian() {
  apt-get -y update

  dpkg -l | grep " git " > /dev/null
  if [ $? -ne 0 ]
  then
    : "----- install git"
    apt-get -y --no-install-recommends install git ca-certificates
  fi
}

function uninstall_git_debian() {
  : "----- uninstall git"
  apt-get -y remove --purge git
}

declare BRANCH=master
declare ONLOCAL="false"
while true; do
  case "$1" in
    -h | --help ) usage; exit 1 ;;
    -b | --branch ) BRANCH=$2; shift 2 ;;
    --local ) ONLOCAL="true"; shift 1 ;;
    * ) break ;;
  esac
done

(( $# < 2 )) && { echo "2 arguements is required."; exit 1; }

declare -r PLATFORM=${1}
declare -r SCRIPT=${2}
shift 2

# check assigned platform
case ${PLATFORM} in
  centos*|fedora*|amazon*)
    : "----- platform is rhel family"
    ;;
  debian*|ubuntu*)
    : "----- platform is debian family"
    ;;
  *)
    echo "platform ${PLATFORM} is invalid"
    exit 1
    ;;
esac

declare WORKDIR=.

if [ "${ONLOCAL}" = "false" ]
then
  WORKDIR=${HOME}/work
  [ -d ${WORKDIR} ] || mkdir ${WORKDIR}
  pushd ${WORKDIR}

  # install git
  case ${PLATFORM} in
    centos*|fedora*|amazon*)
      install_git_centos
      ;;
    debian*|ubuntu*)
      install_git_debian
      ;;
    *)
      echo "platform ${PLATFORM} is invalid"
      exit 1
      ;;
  esac

  # setup provisioning-bash
  : "----- clone provisioning-bash"
  declare -r REPOS_NAME=provisioning-bash
  [ -d ${REPOS_NAME} ] || git clone https://github.com/goldeneggg/${REPOS_NAME}

  pushd ${REPOS_NAME}
  if [ ${BRANCH} != "master" ]
  then
    : "----- switch branch to ${BRANCH}"
    git branch ${BRANCH} origin/${BRANCH}
    git checkout ${BRANCH}
  fi

  : "----- pull --rebase"
  git pull --rebase origin ${BRANCH}

  # uninstall git
  case ${PLATFORM} in
    centos*|fedora*|amazon*)
      uninstall_git_centos
      ;;
    debian*|ubuntu*)
      uninstall_git_debian
      ;;
    *)
      echo "platform ${PLATFORM} is invalid"
      exit 1
      ;;
  esac
fi

pushd ${PLATFORM}

: "----- create log dir"
declare -r LOGDIR=logs
[ -d ${LOGDIR} ] || mkdir ${LOGDIR}

: "----- execute provisioning script"
bash ${SCRIPT} $@ 2>&1 | tee ${LOGDIR}/${SCRIPT}.log
