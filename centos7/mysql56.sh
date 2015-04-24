#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# root only
if [ ${MYUSER} != "root" ]
then
  echo "${MYUSER} can not run ${MYNAME}"
  exit 1
fi

# repository package
declare -r REPO_RPM=mysql-community-release-el7-5.noarch.rpm
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
#mysql -u root -e "DROP USER ''@'localhost';"
