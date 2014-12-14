#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Setup mysql 5.6 community server environment
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

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
${WGETCMD} http://dev.mysql.com/get/${APT_DEB}

# add mysql apt repository
# Note: This task needs interactive user operation. So it's not possible to be automatically...
dpkg -i ${APT_DEB}
apt-get -y update

# install
apt-get -y install mysql-server

# start
service mysql start

# security
## drop noname user
#mysql -u root -e "DROP USER ''@'localhost';"
