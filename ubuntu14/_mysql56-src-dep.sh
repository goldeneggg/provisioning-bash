#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# install dependencies
${PRVENV_CMD_PKG_INS} build-essential cmake bison libncurses5-dev
