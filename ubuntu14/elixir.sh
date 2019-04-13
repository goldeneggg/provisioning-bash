#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- download and install erlang-solutions"
${PRVENV_WGETCMD} https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb

: "----- install Erlang/OTP platform and all of its applications"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} esl-erlang

: "----- install Elixir"
${PRVENV_CMD_PKG_INS} elixir
