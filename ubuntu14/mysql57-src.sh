#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

bash ${MYDIR}/_mysql57-src-dep.sh

: "----- download mysql"
# args
## 1 = server id
## 2 = minor version
declare -r SERVER_ID=${1:-1}
declare -r MINOR_VER=${2:-"17"}
echo "server id = ${SERVER_ID}"

declare -r MAJOR_VER="5.7"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=mysql-${VER}.tar.gz

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
## https://dev.mysql.com/doc/refman/5.7/en/source-configuration-options.html
## https://dev.mysql.com/doc/refman/5.7/en/installing-source-distribution.html
## https://dev.mysql.com/doc/refman/5.7/en/server-management-using-systemd.html
pushd mysql-${VER}
mkdir bld
pushd bld
cmake .. \
-DCMAKE_INSTALL_PREFIX=${PREFIX} \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLE_DOWNLOADS=1 \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=1 \
-DWITH_SYSTEMD=1

make
make install

: "----- symlink versioning mysql to non-versioning mysql"
[ -d ${MYSQL_HOME} -o -L ${MYSQL_HOME} ] && rm -fr ${MYSQL_HOME}
ln -s ${MYSQL_HOME}-${VER} ${MYSQL_HOME}

: "----- add user and group for mysql"
# https://dev.mysql.com/doc/refman/5.7/en/binary-installation.html
# https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization.html
declare -r GRP_MYSQL=mysql
declare -r USER_MYSQL=mysql
set +e
groupadd ${GRP_MYSQL}
useradd -r -g ${GRP_MYSQL} ${USER_MYSQL}
set -e

pushd ${MYSQL_HOME}
chown -R ${USER_MYSQL}:${GRP_MYSQL} .

# http://dev.mysql.com/doc/refman/5.7/en/server-default-configuration-file.html
# http://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html
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
# https://dev.mysql.com/doc/refman/5.7/en/server-options.html
# https://dev.mysql.com/doc/refman/5.7/en/binary-installation.html
# https://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization.html

# --initialize option : generation of a random initial root password
#bin/mysqld --initialize --user=${USER_MYSQL}
# --initialize-insecure option : no root password is generated
bin/mysqld --initialize-insecure --user=${USER_MYSQL}

# https://dev.mysql.com/doc/refman/5.7/en/mysql-ssl-rsa-setup.html
bin/mysql_ssl_rsa_setup

chown -R root:root .
chown -R ${USER_MYSQL}:${GRP_MYSQL} data

: "----- add mysql bin path into bashrc"
echo "export PATH=${MYSQL_HOME}/bin"':$PATH' >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u

: "----- register and start mysql service"
# https://dev.mysql.com/doc/refman/5.7/en/starting-server.html
cp support-files/${SERVICE_FILE} ${INIT_SCRIPT}
chmod +x ${INIT_SCRIPT}

${INIT_SCRIPT} start

${PRVENV_CMD_SERVICE} ${SERVICE_FILE} on
