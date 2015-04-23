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
## 1 = slave server id
## 2 = replication master host
## 3 = replication password
declare SERVER_ID=2
declare MASTER_HOST="192.168.56.150"
declare REPL_PW="p4ssword"
if [ $# -ge 1 ]
then
  SERVER_ID=${1}
  echo "ARGS(1) = slave server id = ${SERVER_ID}"
fi
if [ $# -ge 2 ]
then
  MASTER_HOST=${2}
  echo "ARGS(2) = replication master host = ${MASTER_HOST}"
fi
if [ $# -ge 3 ]
then
  REPL_PW=${3}
  echo "ARGS(3) = replication password = ${REPL_PW}"
fi

declare -r MYSQL_HOME=/usr/local/mysql
declare -r MY_CNF=${MYSQL_HOME}/my.cnf

addToMycnf() {
  for s in ${@}
  do
    echo ${s} >> ${MY_CNF}
  done
  echo '' >> ${MY_CNF}
}

declare -r IFS_BK=${IFS}
IFS=$'\n'
# add slave settings into my.cnf
## See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
declare -ar SLAVE_CNFS=(
  '# replication settings (slave)'
  "server_id = ${SERVER_ID}"
  'read_only = 1'
  'relay_log = /usr/local/mysql/data/mysql-relay-bin'
  'sync_master_info = 1'
  'sync_relay_log = 1'
  'sync_relay_log_info = 1'
  'log_slave_updates = 1'
  'skip_slave_start = 1'
)
grep "${SLAVE_CNFS[0]}" ${MY_CNF} > /dev/null
if [ $? -ne 0 ]
then
  addToMycnf "${SLAVE_CNFS[@]}"
  echo "Add slave settings into ${MY_CNF}"
fi
IFS=${IFS_BK}

# restart
/etc/init.d/mysql.server restart

# get master info
declare -r MYSQL_CMD=${MYSQL_HOME}/bin/mysql
declare -r REPL_USER="repl"

declare -r MAS_INFO=$(echo 'SHOW MASTER STATUS' | ${MYSQL_CMD} -u ${REPL_USER} -p${REPL_PW} -h ${MASTER_HOST})
declare -r LOG_FILE=$(echo ${MAS_INFO} | awk '{print $6}')
declare -r echo "CURRENT LOG_FILE=${LOG_FILE}"
declare -r LOG_POS=$(echo ${MAS_INFO} | awk '{print $7}')
echo "CURRENT LOG_POS=${LOG_POS}"

# initial start replication by CHANGE MASTER
## Note: Before change master, run "show master status" and check "master_log_file" and "master_log_pos"
declare -r MASTER_LOG="mysql-bin.000001"
#${MYSQL_CMD} -u root -e "STOP SLAVE"
${MYSQL_CMD} -u root -e "RESET SLAVE"
${MYSQL_CMD} -u root -e "CHANGE MASTER TO MASTER_HOST = '${MASTER_HOST}', MASTER_USER = '${REPL_USER}', MASTER_PASSWORD = '${REPL_PW}', MASTER_LOG_FILE = '${MASTER_LOG}', MASTER_LOG_POS = 0"

# confirm slave status (before)
${MYSQL_CMD} -u root -e "SHOW SLAVE STATUS \G"

# start slave
echo "START SLAVE"
${MYSQL_CMD} -u root -e "START SLAVE"

# confirm slave status (after)
${MYSQL_CMD} -u root -e "SHOW SLAVE STATUS \G"
