#!/bin/bash

WORKDIR=/tmp/work
ROOT_WORKDIR=/tmp/root_work
ENTRY=entry.sh
PLATFORM=amazon1

# provisioning for root
ROOT_TARGETS=("init.sh")
if [ ${#ROOT_TARGETS[@]} -ne 0 ]
then
  echo "ROOT_TARGETS=${ROOT_TARGETS}"
  sudo mkdir -p ${ROOT_WORKDIR}
  sudo curl -fLsS https://git.io/prv-bash -o ${ROOT_WORKDIR}/${ENTRY}
  sudo chmod +x ${ROOT_WORKDIR}/${ENTRY}

  for t in ${ROOT_TARGETS[@]}
  do
    echo "Run ${t} by root"
    sudo bash ${ROOT_WORKDIR}/${ENTRY} ${PLATFORM} ${t}
  done
fi

# provisioning for user
TARGETS=()

if [ ${#TARGETS[@]} -ne 0 ]
then
  echo "TARGETS=${TARGETS}"
  mkdir -p ${WORKDIR}
  curl -fLsS https://git.io/prv-bash -o ${WORKDIR}/${ENTRY}
  chmod +x ${WORKDIR}/${ENTRY}

  for t in ${TARGETS[@]}
  do
    echo "Run {t} by user"
    bash ${WORKDIR}/${ENTRY} ${PLATFORM} ${t}
  done
fi
