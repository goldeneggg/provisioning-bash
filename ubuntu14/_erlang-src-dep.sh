#!/bin/bash


: "----- install package dependencies for mysql"
${PRVENV_CMD_PKG_INS} build-essential libncurses-dev libssl-dev systemtap-sdt-dev libsctp-dev fop systemtap xsltproc
