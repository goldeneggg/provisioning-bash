#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- install package dependencies for ruby"
${PRVENV_CMD_PKG_INS} libffi-dev zlib1g-dev libssl-dev
