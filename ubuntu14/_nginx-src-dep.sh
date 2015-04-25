#!/bin/bash


: "----- install package dependencies for nginx"
${PRVENV_CMD_PKG_INS} zlib1g-dev libpcre3 libpcre3-dev libssl-dev
