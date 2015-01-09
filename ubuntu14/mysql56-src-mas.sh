#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# prepare dependency
bash ${MYDIR}/mysql56-src.sh

# args
## 1 = replication ip address
## 2 = replication password
REPL_IP="192.168.56.%"
REPL_PW="p4ssword"
if [ $# -ge 1 ]
then
  REPL_IP=${1}
  echo "ARGS(1) = replication ip address = ${REPL_IP}"
fi
if [ $# -ge 2 ]
then
  REPL_PW=${2}
  echo "ARGS(2) = replication password = ${REPL_PW}"
fi

MYSQL_HOME=/usr/local/mysql
MY_CNF=${MYSQL_HOME}/my.cnf

addToMycnf() {
  for s in ${@}
  do
    echo ${s} >> ${MY_CNF}
  done
  echo '' >> ${MY_CNF}
}

# create replication account
MYSQL_CMD=${MYSQL_HOME}/bin/mysql

${MYSQL_CMD} -u root -e "GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO repl@'${REPL_IP}' IDENTIFIED BY '${REPL_PW}'"

IFS_BK=${IFS}
IFS=$'\n'
# add replication settings into my.cnf
## See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
REPL_CNFS=(
  '# replication settings (master)'
  'server_id = 1'
  'sync_binlog = 1'
  )
grep "${REPL_CNFS[0]}" ${MY_CNF} > /dev/null
if [ $? -ne 0 ]
then
  addToMycnf "${REPL_CNFS[@]}"
  echo "Add replication settings into ${MY_CNF}"
fi

# http://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit
# http://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html#sysvar_innodb_support_xa
# See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
INNO_CNFS=(
  '# additional innodb settings for master'
  'innodb_flush_log_at_trx_commit = 1'
  'innodb_support_xa = 1'
)
grep "${INNO_CNFS[0]}" ${MY_CNF} > /dev/null
if [ $? -ne 0 ]
then
  addToMycnf "${INNO_CNFS[@]}"
  echo "Add InnoDB settings into ${MY_CNF}"
fi
IFS=${IFS_BK}

# restart
/etc/init.d/mysql.server restart

# confirm master status
${MYSQL_CMD} -u root -e "SHOW MASTER STATUS \G"

# create dummy database
${MYSQL_CMD} -u root -e "CREATE DATABASE dummy"

# create dummy table
${MYSQL_CMD} -u root -e "CREATE TABLE dummy_work (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(20) DEFAULT NULL,
  age int(11) DEFAULT NULL,
  etc varchar(128) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8" dummy

${MYSQL_CMD} -u root -e "INSERT INTO dummy_work (
  name,
  age,
  etc
  ) VALUES (
  'name1',
  15,
  'etc1111111111111111111111111111111'
)" dummy

# create app account
APPUSER_IP="localhost"
${MYSQL_CMD} -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE ON *.* TO app@'${APPUSER_IP}'"
