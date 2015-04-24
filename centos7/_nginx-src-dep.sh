#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# install dependencies
${PRVENV_CMD_PKG_INS} zlib-devel pcre pcre-devel openssl-devel
