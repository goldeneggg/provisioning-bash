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

# download mysql
# http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.22.tar.gz
MAJOR_VER="5.6"
MINOR_VER="22"
VER=${MAJOR_VER}.${MINOR_VER}
TAR=mysql-${VER}.tar.gz

cd ~
if [ -f ${TAR} ]
then
  rm -f ${TAR}
fi
${WGETCMD} http://dev.mysql.com/get/Downloads/MySQL-${MAJOR_VER}/${TAR}

# install dependencies
bash ${MYDIR}/mysql56-src-dep.sh

# un-archive
if [ -d mysql-${VER} ]
then
  rm -fr mysql-${VER}
fi
tar zxf ${TAR}

# cmake
## http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html
## http://dev.mysql.com/doc/refman/5.6/en/source-installation-layout.html
## http://dev.mysql.com/doc/refman/5.6/en/installing-source-distribution.html
## http://dev.mysql.com/doc/refman/5.6/en/compilation-problems.html
PREFIX=/usr/local/mysql-${VER}

cd mysql-${VER}
mkdir bld
cd bld
cmake .. \
-DCMAKE_INSTALL_PREFIX=${PREFIX} \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLE_DOWNLOADS=1

# make, install
make
make install

MYSQL_HOME=/usr/local/mysql
if [ -d ${MYSQL_HOME} -o -L ${MYSQL_HOME} ]
then
  rm -fr ${MYSQL_HOME}
fi
ln -s /usr/local/mysql-${VER} ${MYSQL_HOME}

# initial setup
## http://dev.mysql.com/doc/refman/5.6/en/installing-source-distribution.html
GRP_MYSQL=mysql
USER_MYSQL=mysql
groupadd ${GRP_MYSQL}
useradd -r -g ${GRP_MYSQL} ${USER_MYSQL}
cd /usr/local/mysql
chown -R ${USER_MYSQL}:${GRP_MYSQL} .
## creates a default option file named my.cnf in the base installation directory.
### http://dev.mysql.com/doc/refman/5.6/en/server-default-configuration-file.html
### http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html
scripts/mysql_install_db --user=mysql
chown -R root:root .
chown -R ${USER_MYSQL}:${GRP_MYSQL} data
## mk log dir
mkdir log
chown -R ${USER_MYSQL}:${GRP_MYSQL} log

# create my.cnf
## XXX: Does not this operation need to execute?
### http://dev.mysql.com/doc/refman/5.6/en/server-default-configuration-file.html
### http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html
COPY_TARGETS=("/usr/local/mysql/my.cnf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# create service script
cp support-files/mysql.server /etc/init.d/
chmod +x /etc/init.d/mysql.server

# start
/etc/init.d/mysql.server start

# set environments
echo "export PATH=${MYSQL_HOME}/bin"':$PATH' >> /etc/bash.bashrc

# drop noname user
#bin/mysql -u root -e "DROP USER ''@'localhost'"

# set root password
#bin/mysqladmin -u root password "root"

