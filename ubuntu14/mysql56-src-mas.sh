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

# prepare dependency
bash ${MYDIR}/mysql56-src.sh

# args
## 1 = replication ip address
## 2 = replication password
declare -r REPL_IP=${1:-"192.168.56.%"}
declare -r REPL_PW=${2:-"p4ssword"}
echo "replication ip address = ${REPL_IP}"
echo "replication password = ${REPL_PW}"

declare -r MYSQL_HOME=/usr/local/mysql
declare -r MY_CNF=${MYSQL_HOME}/my.cnf

function addToMycnf {
  for s in ${@}
  do
    echo ${s} >> ${MY_CNF}
  done
  echo '' >> ${MY_CNF}
}

# create replication account
declare -r MYSQL_CMD=${MYSQL_HOME}/bin/mysql

${MYSQL_CMD} -u root -e "GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO repl@'${REPL_IP}' IDENTIFIED BY '${REPL_PW}'"

declare -r IFS_BK=${IFS}
IFS=$'\n'

# add replication settings into my.cnf
## See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
declare -ar REPL_CNFS=(
  '# replication settings (master)'
  'server_id = 1'
  'sync_binlog = 1'
  )

grep "${REPL_CNFS[0]}" ${MY_CNF} > /dev/null
if (( $? ))
then
  addToMycnf "${REPL_CNFS[@]}"
  echo "Add replication settings into ${MY_CNF}"
fi

# http://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit
# http://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html#sysvar_innodb_support_xa
# See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
declare -ar INNO_CNFS=(
  '# additional innodb settings for master'
  'innodb_flush_log_at_trx_commit = 1'
  'innodb_support_xa = 1'
  'innodb_file_per_table'
  'innodb_file_format = Barracuda' # for utf8mb4
  'innodb_large_prefix' # for utf8mb4
)

grep "${INNO_CNFS[0]}" ${MY_CNF} > /dev/null
if (( $? ))
then
  addToMycnf "${INNO_CNFS[@]}"
  echo "Add InnoDB settings into ${MY_CNF}"
fi
IFS=${IFS_BK}

# restart
/etc/init.d/mysql.server restart

declare -r MYSQL_USER=root

# confirm master status
${MYSQL_CMD} -u ${MYSQL_USER} -e "SHOW MASTER STATUS \G"

# create dummy database
${MYSQL_CMD} -u ${MYSQL_USER} -e "CREATE DATABASE dummy"

# create dummy table
${MYSQL_CMD} -u ${MYSQL_USER} -e \
"CREATE TABLE dummy_work (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(20) DEFAULT NULL,
  age int(11) DEFAULT NULL,
  etc varchar(128) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4" \
dummy

${MYSQL_CMD} -u ${MYSQL_USER} -e \
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

# create app account
declare -r APPUSER_IP="localhost"
${MYSQL_CMD} -u ${MYSQL_USER} -e \
"GRANT SELECT,INSERT,UPDATE,DELETE
ON *.*
TO app@'${APPUSER_IP}'"

# create remote ${MYSQL_USER} account
declare -r REM_ROOTUSER_IP="192.168.56.%"
${MYSQL_CMD} -u ${MYSQL_USER} -e \
"GRANT CREATE,DROP,INDEX,ALTER,SELECT,INSERT,UPDATE,DELETE
ON *.*
TO ${MYSQL_USER}@'${REM_ROOTUSER_IP}'"
