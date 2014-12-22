#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# prepare dependency
bash ${MYDIR}/mysql56-src.sh

MYSQL_HOME=/usr/local/mysql
MY_CNF=${MYSQL_HOME}/my.cnf

addToMycnf() {
  for s in ${@}
  do
    echo ${s} >> ${MY_CNF}
  done
  echo '' >> ${MY_CNF}
}

IFS_BK=${IFS}
IFS=$'\n'
# add slave settings into my.cnf
## See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
SERVER_ID=2
SLAVE_CNFS=(
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
MYSQL_CMD=${MYSQL_HOME}/bin/mysql
MASTER_HOST="192.168.56.150"
REPL_USER="repl"
REPL_PW="p4ssword"

MAS_INFO=$(echo 'SHOW MASTER STATUS' | ${MYSQL_CMD} -u ${REPL_USER} -p${REPL_PW} -h ${MASTER_HOST})
LOG_FILE=$(echo ${MAS_INFO} | awk '{print $6}')
echo "CURRENT LOG_FILE=${LOG_FILE}"
LOG_POS=$(echo ${MAS_INFO} | awk '{print $7}')
echo "CURRENT LOG_POS=${LOG_POS}"

# initial start replication by CHANGE MASTER
## Note: Before change master, run "show master status" and check "master_log_file" and "master_log_pos"
MASTER_LOG="mysql-bin.000001"
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
