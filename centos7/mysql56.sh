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

# repository package
REPO_RPM=mysql-community-release-el7-5.noarch.rpm
cd /tmp
if [ -f ${REPO_RPM} ]
then
  rm -f ${REPO_RPM}
fi
${WGETCMD} http://dev.mysql.com/get/${REPO_RPM}

# install repository package
rpm -Uvh ${REPO_RPM}

# install
yum -y install mysql-community-server

# start
systemctl start mysqld

# security
## drop noname user
mysql -u root -e "DROP USER ''@'localhost';"
