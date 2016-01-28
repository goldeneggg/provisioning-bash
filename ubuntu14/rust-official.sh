#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

: "----- install rust"
curl -sSf https://static.rust-lang.org/rustup.sh | sh -s -- -y
