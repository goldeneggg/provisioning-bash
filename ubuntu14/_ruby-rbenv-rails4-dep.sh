#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- install package dependencies for rails4"
${PRVENV_CMD_PKG_INS} sqlite3 libsqlite3-dev
