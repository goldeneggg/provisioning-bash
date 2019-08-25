#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

bash ${MYDIR}/_mysql80-src-dep.sh

: "----- download mysql"
# args
## 1 = server id
## 2 = minor version
declare -r SERVER_ID=${1:-1}
declare -r MINOR_VER=${2:-"17"}
echo "server id = ${SERVER_ID}"

declare -r MAJOR_VER="8.0"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TARNAME=mysql-${VER}
declare -r TAR=${TARNAME}.tar.gz

pushd ${PRVENV_INSTALL_WORK_DIR}
[ -f ${TAR} ] && rm -f ${TAR}

${PRVENV_WGETCMD} http://dev.mysql.com/get/Downloads/MySQL-${MAJOR_VER}/${TAR}

: "----- check already executing mysql"
declare -r SERVICE_FILE=mysql.server
declare -r INIT_SCRIPT=/etc/init.d/${SERVICE_FILE}
declare -r SOCK_FILE=/tmp/mysql.sock

[ -x ${INIT_SCRIPT} -a -f ${SOCK_FILE} ] && ${INIT_SCRIPT} stop

[ -d mysql-${VER} ] && rm -fr mysql-${VER}
tar zxf ${TAR}

: "----- make and install mysql using cmake"
declare -r MYSQL_HOME=/usr/local/mysql
declare -r PREFIX=${MYSQL_HOME}-${VER}

# cmake
## https://dev.mysql.com/doc/refman/8.0/en/source-configuration-options.html
## https://dev.mysql.com/doc/refman/8.0/en/installing-source-distribution.html
## https://dev.mysql.com/doc/refman/8.0/en/using-systemd.html
pushd mysql-${VER}
mkdir bld
pushd bld

cmake .. \
-DCMAKE_INSTALL_PREFIX=${PREFIX} \
-DENABLED_LOCAL_INFILE=ON \
-DWITH_ARCHIVE_STORAGE_ENGINE=ON \
-DENABLE_DOWNLOADS=ON \
-DDOWNLOAD_BOOST=ON \
-DWITH_BOOST=/tmp/boost \
-DWITH_SYSTEMD=ON \
-DINSTALL_SECURE_FILE_PRIVDIR=/tmp/ \
-DWITH_DEBUG=ON \
-DWITH_INNODB_EXTRA_DEBUG=ON

make
make install

: "----- symlink versioning mysql to non-versioning mysql"
[ -d ${MYSQL_HOME} -o -L ${MYSQL_HOME} ] && rm -fr ${MYSQL_HOME}
ln -s ${MYSQL_HOME}-${VER} ${MYSQL_HOME}

: "----- add user and group for mysql"
# https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html
# https://dev.mysql.com/doc/refman/8.0/en/data-directory-initialization.html
declare -r GRP_MYSQL=mysql
declare -r USER_MYSQL=mysql
set +e
groupadd ${GRP_MYSQL}
useradd -r -g ${GRP_MYSQL} ${USER_MYSQL}
set -e

pushd ${MYSQL_HOME}
chown -R ${USER_MYSQL}:${GRP_MYSQL} .

# http://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html
: "----- copy customize configuration files"
declare -r COPY_TARGETS=("${MYSQL_HOME}/my.cnf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

: "----- append server_id into my.cnf"
echo "server_id = ${SERVER_ID}" >> ${MYSQL_HOME}/my.cnf

[ -d log ] || mkdir log
chown -R ${USER_MYSQL}:${GRP_MYSQL} log

: "----- mysql initial setup"
# creates a default option file named my.cnf in the base installation directory.
# https://dev.mysql.com/doc/refman/8.0/en/server-options.html
# https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html
# https://dev.mysql.com/doc/refman/8.0/en/data-directory-initialization.html

# --initialize option : generation of a random initial root password
#bin/mysqld --initialize --user=${USER_MYSQL}
# --initialize-insecure option : no root password is generated
bin/mysqld --initialize-insecure --user=${USER_MYSQL}

# https://dev.mysql.com/doc/refman/8.0/en/mysql-ssl-rsa-setup.html
bin/mysql_ssl_rsa_setup

chown -R root:root .
chown -R ${USER_MYSQL}:${GRP_MYSQL} data

: "----- add mysql bin path into bashrc"
echo "export PATH=${MYSQL_HOME}/bin"':$PATH' >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u

: "----- register and start mysql service using systemd"
# https://dev.mysql.com/doc/refman/8.0/en/using-systemd.html
declare -r MYSQLD_SERVICE_NAME=mysqld
declare -r MYSQLD_SERVICE_FILE=${MYSQL_HOME}/${MYSQLD_SERVICE_NAME}.service

cp ${MYSQLD_SERVICE_FILE} ${PRVENV_SYSTEM_SYSTEMD_DIR}/

${PRVENV_CMD_INIT_RELOAD}

declare -r MYSQLD_PID_DIR=/var/run/${MYSQLD_SERVICE_NAME}
mkdir -p ${MYSQLD_PID_DIR}
chown -R ${USER_MYSQL}:${GRP_MYSQL} ${MYSQLD_PID_DIR}
${PRVENV_CMD_INIT_RESTART} ${MYSQLD_SERVICE_NAME}
