#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# install dependencies
${PRVENV_CMD_PKG_INS} libffi-dev zlib1g-dev libssl-dev
