#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# install dependencies
${PRVENV_CMD_PKG_INS} build-essential cmake bison ncurses-devel
