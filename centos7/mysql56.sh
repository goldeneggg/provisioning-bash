#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || (echo "${MYUSER} can not run ${MYNAME}"; exit 1)

# repository package
pushd ${PRVENV_INSTALL_WORK_DIR}

declare -r REPO_RPM=mysql-community-release-el7-5.noarch.rpm
[ -f ${REPO_RPM} ] && rm -f ${REPO_RPM}
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
