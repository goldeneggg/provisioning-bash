#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# prepare dependency
bash ${MYDIR}/init_ja.sh

# download mysql apt repository
# http://dev.mysql.com/get/mysql-apt-config_0.3.2-1ubuntu14.04_all.deb
APTCONF_VER="0.3.2-1"
APT_DEB=mysql-apt-config_${APTCONF_VER}ubuntu14.04_all.deb

cd /tmp
if [ -f ${APT_DEB} ]
then
  rm -f ${APT_DEB}
fi
${PRVENV_WGETCMD} http://dev.mysql.com/get/${APT_DEB}

# add mysql apt repository
# Note: This task needs interactive user operation. So it's not possible to be automatically...
${PRVENV_CMD_LOCAL_PKG_INS} ${APT_DEB}
${PRVENV_CMD_PKG_UPD}

# install
${PRVENV_CMD_PKG_INS} mysql-server

# start
/etc/init.d/mysql start

# security
## drop noname user
#mysql -u root -e "DROP USER ''@'localhost';"
