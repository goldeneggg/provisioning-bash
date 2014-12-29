#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# initial setup
bash ${MYDIR}/init_ja.sh

# add nginx repository
${PRVENV_CMD_LOCAL_PKG_INS} http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

# install
${PRVENV_CMD_PKG_INS} nginx

## port open for nginx
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# start
${PRVENV_CMD_INIT_ENABLE} nginx
${PRVENV_CMD_INIT_START} nginx
