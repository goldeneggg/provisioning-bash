#!/bin/bash


: "----- install package dependencies for mysql"
# https://dev.mysql.com/doc/refman/8.0/en/source-installation.html
${PRVENV_CMD_PKG_INS} build-essential cmake bison libncurses5-dev libboost-all-dev
