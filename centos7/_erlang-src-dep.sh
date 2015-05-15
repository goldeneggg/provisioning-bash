#!/bin/bash


: "----- install package dependencies for erlang"
${PRVENV_CMD_PKG_INS} autoconf ncurses-devel openssl-devel systemtap systemtap-sdt-devel lksctp-tools lksctp-tools-devel fop
