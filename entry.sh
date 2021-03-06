#!/bin/bash

set -ux


: "----- check whoami"
declare -r WHOAMI=$(whoami)
echo "whoami = ${WHOAMI}"
declare SUDOCMD=""
if [ "${WHOAMI}" != "root" ]
then
  SUDOCMD="sudo "
fi


function usage {
  cat << EOT
Usage: $0 [Options] PLATFORM SCRIPT_NAME [OTHER ARGS...]

Provisioner's facade script

Options:
  -b | --branch          target branch
  --local                use local files(not clone from github.com)
  -h | --help            print a summary of the options

EOT
}

function install_git_centos() {
  ${SUDOCMD}yum -y update

  rpm -ql git > /dev/null
  if [ $? -ne 0 ]
  then
    : "----- install git"
    ${SUDOCMD}yum -y install git
  fi
}

function uninstall_git_centos() {
  : "----- uninstall git"
  ${SUDOCMD}yum -y remove git
}

function install_git_debian() {
  ${SUDOCMD}apt-get -y update

  dpkg -l | grep " git " > /dev/null
  if [ $? -ne 0 ]
  then
    : "----- install git"
    ${SUDOCMD}apt-get -y --no-install-recommends install git ca-certificates
  fi
}

function uninstall_git_debian() {
  : "----- uninstall git"
  ${SUDOCMD}apt-get -y remove --purge git
}

function install_git_alpine() {
  ${SUDOCMD}apk --no-cache update

  apk info git > /dev/null
  if [ $? -ne 0 ]
  then
    : "----- install git"
    #${SUDOCMD}apk --no-cache add git ca-certificates
    ${SUDOCMD}apk --no-cache add git
  fi
}

function uninstall_git_alpine() {
  : "----- uninstall git"
  ${SUDOCMD}apk del --purge git
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
    export DEBIAN_FRONTEND=noninteractive
    ;;
  alpine*)
    : "----- platform is alpine family"
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
    alpine*)
      install_git_alpine
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

  # # uninstall git
  # case ${PLATFORM} in
  #   centos*|fedora*|amazon*)
  #     uninstall_git_centos
  #     ;;
  #   debian*|ubuntu*)
  #     uninstall_git_debian
  #     ;;
  #   alpine*)
  #     uninstall_git_alpine
  #     ;;
  #   *)
  #     echo "platform ${PLATFORM} is invalid"
  #     exit 1
  #     ;;
  # esac
fi

pushd ${PLATFORM}

: "----- create log dir"
declare -r LOGDIR=logs
[ -d ${LOGDIR} ] || mkdir ${LOGDIR}

: "----- execute provisioning script"
bash ${SCRIPT} $@ 2>&1 | tee ${LOGDIR}/${SCRIPT}.log
