#!/bin/bash

PFS=("amazon1" "centos7" "ubuntu14" "ubuntu18")

function build() {
  for pf in ${PFS[@]}
  do
    : "----- setup ${pf}"
    pushd ${pf}/docker-files
    make build-local

    ret=$?
    if [ ${ret} -ne 0 ]
    then
      echo "Error: ret=${ret}"
      exit ${ret}
    fi

    popd
  done
}

function run() {
  for pf in ${PFS[@]}
  do
    : "----- setup ${pf}"
    pushd ${pf}/docker-files
    make test

    ret=$?
    if [ ${ret} -ne 0 ]
    then
      echo "Error: ret=${ret}"
      exit ${ret}
    fi

    popd
  done
}

eval ${1}
