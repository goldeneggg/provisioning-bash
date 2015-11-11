#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

# args
## 1 = server_id
## 2 = replication ip address
## 3 = replication password
declare -r SERVER_ID=${1:-1}
declare -r REPL_IP=${2:-"192.168.56.%"}
declare -r REPL_PW=${3:-"p4ssword"}
echo "replication ip address = ${REPL_IP}"
echo "replication password = ${REPL_PW}"

bash ${MYDIR}/mysql57-src.sh ${SERVER_ID}

: "----- get temporary root password from log-error
TMP_PASSWD=$(grep "A temporary password is generated" ${MYLOGDIR}/mysql57-src.sh.log | awk '{print $11}')
declare -r ROOT_PASSWD="root#123"
${MYSQL_CMD} -u root -p${TMP_PASSWD} -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWD}'"

: "----- create replication account"
declare -r MYSQL_HOME=/usr/local/mysql
declare -r MYSQL_CMD=${MYSQL_HOME}/bin/mysql
declare -r MYSQL_USER=root
declare -r MYSQL_CMD_LINE="${MYSQL_CMD} -u ${MYSQL_USER} -p${ROOT_PASSWD}"

${MYSQL_CMD_LINE} -e "GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO repl@'${REPL_IP}' IDENTIFIED BY '${REPL_PW}'"

declare -r IFS_BK=${IFS}
IFS=$'\n'

: "----- add replication settings into my.cnf"
# See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
declare -ar REPL_CNFS=(
  '# replication settings (master)'
  'sync_binlog = 1'
  'binlog_format = mixed'
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

: "----- add InnoDB settings into my.cnf"
# http://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit
# http://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_support_xa
# See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
declare -ar INNO_CNFS=(
  '# additional innodb settings for master'
  'innodb_flush_log_at_trx_commit = 1'
  'innodb_support_xa = 1'
  'innodb_file_per_table'
  'innodb_file_format = Barracuda' # for utf8mb4
  'innodb_large_prefix' # for utf8mb4
)

set +e
grep "${INNO_CNFS[0]}" ${MY_CNF} > /dev/null
if (( $? ))
then
  addToMycnf "${INNO_CNFS[@]}"
  echo "Add InnoDB settings into ${MY_CNF}"
fi
set -e

IFS=${IFS_BK}

/etc/init.d/mysql.server restart


: "----- confirm whether mysql installation is succeed"
${MYSQL_CMD_LINE} -e "SHOW MASTER STATUS \G"
${MYSQL_CMD_LINE} -e "CREATE DATABASE dummy"
${MYSQL_CMD_LINE} -e \
"CREATE TABLE dummy_work (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(20) DEFAULT NULL,
  age int(11) DEFAULT NULL,
  etc varchar(128) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4" \
dummy

${MYSQL_CMD_LINE} -e \
"INSERT INTO dummy_work (
  name,
  age,
  etc
  ) VALUES (
  'パパ',
  15,
  'etc1111111111111111111111111111111'
)" \
dummy

: "----- create application account"
declare -r APPUSER_IP="localhost"
${MYSQL_CMD_LINE} -e \
"GRANT SELECT,INSERT,UPDATE,DELETE
ON *.*
TO app@'${APPUSER_IP}'"

: "----- create account with grant for only lan network"
declare -r REM_ROOTUSER_IP="192.168.56.%"
${MYSQL_CMD_LINE} -e \
"GRANT ALL
ON *.*
TO ${MYSQL_USER}@'${REM_ROOTUSER_IP}'"
