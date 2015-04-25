#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- install package dependencies for mysql"
${PRVENV_CMD_PKG_INS} build-essential cmake bison libncurses5-dev
