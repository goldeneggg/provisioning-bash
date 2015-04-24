#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# install dependencies
${PRVENV_CMD_PKG_INS} libffi-devel zlib-devel openssl-devel
