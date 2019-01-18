#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## 1 = server_id
## 2 = replication ip address
## 3 = replication password
declare -r SERVER_ID=${1:-1}
declare -r REPL_IP=${2:-"192.168.56.%"}
declare -r REPL_PW=${3:-"p4ss=Word"}
echo "replication ip address = ${REPL_IP}"
echo "replication password = ${REPL_PW}"

bash ${MYDIR}/mysql80-src.sh ${SERVER_ID}

declare -r MYSQL_HOME=/usr/local/mysql
declare -r MYSQL_CMD=${MYSQL_HOME}/bin/mysql
declare -r MYSQL_USER=root

## if installed by "mysqld --initialize" command, temporary password is set.
#: "----- get temporary root password from log-error"
#TMP_PASSWD=$(grep "A temporary password is generated" ${MYLOG} | awk '{print $11}')

: "----- set root user password"
declare -r ROOT_PASSWD="root#123"
#${MYSQL_CMD} -u ${MYSQL_USER} -p${TMP_PASSWD} --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWD}'"
${MYSQL_CMD} -u ${MYSQL_USER} -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWD}'"

declare -r MYSQL_CMD_LINE="${MYSQL_CMD} -u ${MYSQL_USER} -p${ROOT_PASSWD}"

: "----- create replication account"
# See: http://next4us-ti.hatenablog.com/entry/2018/07/13/123322<Paste>
${MYSQL_CMD_LINE} -e "CREATE USER repl@'${REPL_IP}' IDENTIFIED BY '${REPL_PW}'"
${MYSQL_CMD_LINE} -e "GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO repl@'${REPL_IP}'"

declare -r IFS_BK=${IFS}
IFS=$'\n'

: "----- add replication settings into my.cnf"
# See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
declare -ar REPL_CNFS=(
  '# replication settings (master)'
  'binlog_format = MIXED'
  )

declare -r MY_CNF=${MYSQL_HOME}/my.cnf

function addToMycnf {
  for s in ${@}
  do
    echo ${s} >> ${MY_CNF}
  done
  echo '' >> ${MY_CNF}
}

set +e
grep "${REPL_CNFS[0]}" ${MY_CNF} > /dev/null
if (( $? ))
then
  addToMycnf "${REPL_CNFS[@]}"
  echo "Add replication settings into ${MY_CNF}"
fi
set -e

: "----- add InnoDB settings into my.cnf (Nothing to do! on 8.0)"
# http://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit
# See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"

IFS=${IFS_BK}

: "----- restart mysqld"
declare -r MYSQLD_SERVICE_NAME=mysqld
${PRVENV_CMD_INIT_RESTART} ${MYSQLD_SERVICE_NAME}

: "----- confirm whether mysql installation is succeed by creating dummy table"
DBNAME=dummy
${MYSQL_CMD_LINE} -e "SHOW MASTER STATUS \G"
${MYSQL_CMD_LINE} -e "CREATE DATABASE ${DBNAME}"
${MYSQL_CMD_LINE} -D ${DBNAME} << EOS
CREATE TABLE dummy_work (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(20) DEFAULT NULL,
  age int(11) DEFAULT NULL,
  etc varchar(128) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4
EOS

${MYSQL_CMD_LINE} -D ${DBNAME} << EOS
INSERT INTO dummy_work (
  name,
  age,
  etc
  ) VALUES (
  'パパ',
  15,
  'etc1111111111111111111111111111111'
)
EOS

: "----- download example data files provided mysql official"
pushd /tmp

# world_x database
declare -r EXAMPLE_DB_WORLD_X=world_x-db
${PRVENV_WGETCMD} http://downloads.mysql.com/docs/${EXAMPLE_DB_WORLD_X}.tar.gz
tar zxf ${EXAMPLE_DB_WORLD_X}.tar.gz

# sakila database
declare -r EXAMPLE_DB_SAKILA=sakila-db
${PRVENV_WGETCMD} http://downloads.mysql.com/docs/${EXAMPLE_DB_SAKILA}.tar.gz
tar zxf ${EXAMPLE_DB_SAKILA}.tar.gz

: "----- registered example data into dummy database"
${MYSQL_CMD_LINE} << EOS
SOURCE /tmp/${EXAMPLE_DB_WORLD_X}/world_x.sql
SOURCE /tmp/${EXAMPLE_DB_SAKILA}/sakila-schema.sql
SOURCE /tmp/${EXAMPLE_DB_SAKILA}/sakila-data.sql
EOS

: "----- create application account for localhost and lan network"
# Note: https://bugs.mysql.com/bug.php?id=83822
## can't create no passwd user on 5.7 or later, so "IDENTIFIED BY" must be assigned
declare -r APP_USER_PASSWD=papp

${MYSQL_CMD_LINE} -D ${DBNAME} -e "CREATE USER app@'localhost' IDENTIFIED BY '${APP_USER_PASSWD}'"
${MYSQL_CMD_LINE} -D ${DBNAME} -e "GRANT ALL ON *.* TO app@'localhost'"

${MYSQL_CMD_LINE} -D ${DBNAME} -e "CREATE USER app@'192.168.56.%' IDENTIFIED BY '${APP_USER_PASSWD}'"
${MYSQL_CMD_LINE} -D ${DBNAME} -e "GRANT ALL ON *.* TO app@'192.168.56.%'"

: "----- create root account with grant for only lan network"
declare -r REM_ROOTUSER_IP="192.168.56.%"

${MYSQL_CMD_LINE} -D ${DBNAME} -e "CREATE USER ${MYSQL_USER}@'${REM_ROOTUSER_IP}' IDENTIFIED BY '${ROOT_PASSWD}'"
${MYSQL_CMD_LINE} -D ${DBNAME} -e "GRANT ALL ON *.* TO ${MYSQL_USER}@'${REM_ROOTUSER_IP}'"

# XXX: mysql8-src.sh でmkdir & chownしてるんだけど、作成したvmに後で繋いでみるとdirが消えちゃう という事象に遭遇している
# 解決するか分からないが、もう一度ココで mkdir & chown してみておく
# declare -r MYSQLD_PID_DIR=/var/run/${MYSQLD_SERVICE_NAME}
# mkdir -p ${MYSQLD_PID_DIR}
# chown -R mysql:mysql ${MYSQLD_PID_DIR}
