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

# download mysql
# http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.22.tar.gz
declare -r MAJOR_VER="5.6"
declare -r MINOR_VER="24"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=mysql-${VER}.tar.gz

cd ~
if [ -f ${TAR} ]
then
  rm -f ${TAR}
fi
${PRVENV_WGETCMD} http://dev.mysql.com/get/Downloads/MySQL-${MAJOR_VER}/${TAR}

# check already executing mysql
declare -r SERVICE_FILE=mysql.server
declare -r INIT_SCRIPT=/etc/init.d/${SERVICE_FILE}

if [ -x ${INIT_SCRIPT} ]
then
  ${INIT_SCRIPT} stop
fi

# install dependencies
bash ${MYDIR}/_mysql56-src-dep.sh

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
declare -r PREFIX=/usr/local/mysql-${VER}

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

# symlink
declare -r MYSQL_HOME=/usr/local/mysql
if [ -d ${MYSQL_HOME} -o -L ${MYSQL_HOME} ]
then
  rm -fr ${MYSQL_HOME}
fi
ln -s /usr/local/mysql-${VER} ${MYSQL_HOME}

# initial setup
## http://dev.mysql.com/doc/refman/5.6/en/installing-source-distribution.html
declare -r GRP_MYSQL=mysql
declare -r USER_MYSQL=mysql
groupadd ${GRP_MYSQL}
useradd -r -g ${GRP_MYSQL} ${USER_MYSQL}
cd /usr/local/mysql
chown -R ${USER_MYSQL}:${GRP_MYSQL} .

## creates a default option file named my.cnf in the base installation directory.
### http://dev.mysql.com/doc/refman/5.6/en/server-default-configuration-file.html
### http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html
scripts/mysql_install_db --user=${USER_MYSQL}
chown -R root:root .
chown -R ${USER_MYSQL}:${GRP_MYSQL} data

## mk log dir
mkdir log
chown -R ${USER_MYSQL}:${GRP_MYSQL} log

# create my.cnf
## XXX: Does not this operation need to execute?
### http://dev.mysql.com/doc/refman/5.6/en/server-default-configuration-file.html
### http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html
declare -r COPY_TARGETS=("/usr/local/mysql/my.cnf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# create service script
cp support-files/${SERVICE_FILE} ${INIT_SCRIPT}
chmod +x ${INIT_SCRIPT}

# start
${INIT_SCRIPT} start

# auto start
${PRVENV_CMD_SERVICE} ${SERVICE_FILE} on

# set environments
echo "export PATH=${MYSQL_HOME}/bin"':$PATH' >> ${PRVENV_DEFAULT_BASHRC}
