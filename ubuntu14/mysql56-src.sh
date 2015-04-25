#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || (echo "${MYUSER} can not run ${MYNAME}"; exit 1)

: "----- download mysql"
declare -r MAJOR_VER="5.6"
declare -r MINOR_VER="24"
declare -r VER=${MAJOR_VER}.${MINOR_VER}
declare -r TAR=mysql-${VER}.tar.gz

pushd ${PRVENV_INSTALL_WORK_DIR}
[ -f ${TAR} ] && rm -f ${TAR}

# http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.24.tar.gz
${PRVENV_WGETCMD} http://dev.mysql.com/get/Downloads/MySQL-${MAJOR_VER}/${TAR}

: "----- check already executing mysql"
declare -r SERVICE_FILE=mysql.server
declare -r INIT_SCRIPT=/etc/init.d/${SERVICE_FILE}

[ -x ${INIT_SCRIPT} ] && ${INIT_SCRIPT} stop

bash ${MYDIR}/_mysql56-src-dep.sh

[ -d mysql-${VER} ] && rm -fr mysql-${VER}
tar zxf ${TAR}

: "----- make and install mysql using cmake"
declare -r PREFIX=/usr/local/mysql-${VER}

# cmake
## http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html
## http://dev.mysql.com/doc/refman/5.6/en/source-installation-layout.html
## http://dev.mysql.com/doc/refman/5.6/en/installing-source-distribution.html
## http://dev.mysql.com/doc/refman/5.6/en/compilation-problems.html
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
-DENABLE_DOWNLOADS=1

make
make install

: "----- symlink versioning mysql to non-versioning mysql"
declare -r MYSQL_HOME=/usr/local/mysql
[ -d ${MYSQL_HOME} -o -L ${MYSQL_HOME} ] && rm -fr ${MYSQL_HOME}
ln -s /usr/local/mysql-${VER} ${MYSQL_HOME}

: "----- add user and group for mysql"
# http://dev.mysql.com/doc/refman/5.6/en/installing-source-distribution.html
declare -r GRP_MYSQL=mysql
declare -r USER_MYSQL=mysql
groupadd ${GRP_MYSQL}
useradd -r -g ${GRP_MYSQL} ${USER_MYSQL}

pushd /usr/local/mysql
chown -R ${USER_MYSQL}:${GRP_MYSQL} .

: "----- mysql initial setup"
# creates a default option file named my.cnf in the base installation directory.
## http://dev.mysql.com/doc/refman/5.6/en/server-default-configuration-file.html
## http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html
scripts/mysql_install_db --user=${USER_MYSQL}
chown -R root:root .
chown -R ${USER_MYSQL}:${GRP_MYSQL} data

mkdir log
chown -R ${USER_MYSQL}:${GRP_MYSQL} log

# XXX: Does not this operation need to execute?
## http://dev.mysql.com/doc/refman/5.6/en/server-default-configuration-file.html
## http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html
declare -r COPY_TARGETS=("/usr/local/mysql/my.cnf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

: "----- register and start mysql service"
cp support-files/${SERVICE_FILE} ${INIT_SCRIPT}
chmod +x ${INIT_SCRIPT}

${INIT_SCRIPT} start

${PRVENV_CMD_SERVICE} ${SERVICE_FILE} on

: "----- add mysql bin path into bashrc"
echo "export PATH=${MYSQL_HOME}/bin"':$PATH' >> ${PRVENV_DEFAULT_BASHRC}
