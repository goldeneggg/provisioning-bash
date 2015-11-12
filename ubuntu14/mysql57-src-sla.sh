#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

# args
## 1 = server_id
## 2 = replication master host
## 3 = replication password
declare -r SERVER_ID=${1:-2}
declare -r MASTER_HOST=${2:-"192.168.56.250"}
declare -r REPL_PW=${3:-"p4ssword"}
echo "replication master host = ${MASTER_HOST}"
echo "replication password = ${REPL_PW}"

bash ${MYDIR}/mysql57-src.sh ${SERVER_ID}

declare -r MYSQL_CMD=${MYSQL_HOME}/bin/mysql
declare -r MYSQL_USER=root

: "----- get temporary root password from log-error"
TMP_PASSWD=$(grep "A temporary password is generated" ${MYLOGDIR}/mysql57-src.sh.log | awk '{print $11}')
declare -r ROOT_PASSWD="root#123"
${MYSQL_CMD} -u ${MYSQL_USER} -p${TMP_PASSWD} -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWD}'"

declare -r MYSQL_HOME=/usr/local/mysql
declare -r MYSQL_CMD_LINE="${MYSQL_CMD} -u ${MYSQL_USER} -p${ROOT_PASSWD}"

: "----- add slave settings into my.cnf"
declare -r IFS_BK=${IFS}
IFS=$'\n'

# See: "High Performance MySQL. Chapter10 - Recommended Replication Configuration"
declare -ar SLAVE_CNFS=(
  '# additional innodb settings for slave'
  'innodb_flush_log_at_trx_commit = 1'
  'innodb_support_xa = 1'
  'innodb_file_per_table'
  'innodb_file_format = Barracuda' # for utf8mb4
  'innodb_large_prefix' # for utf8mb4
  '# replication settings (slave)'
  'read_only = 1'
  'relay_log = /usr/local/mysql/data/mysql-relay-bin'
  'sync_master_info = 1'
  'sync_relay_log = 1'
  'sync_relay_log_info = 1'
  'log_slave_updates = 1'
  'skip_slave_start = 1'
  'binlog_format = mixed'
  'binlog_checksum = CRC32'
  'relay_log_info_repository = TABLE'
  'relay_log_recovery = ON'
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
grep "${SLAVE_CNFS[0]}" ${MY_CNF} > /dev/null
if (( $? ))
then
  addToMycnf "${SLAVE_CNFS[@]}"
  echo "Add slave settings into ${MY_CNF}"
fi
set -e

IFS=${IFS_BK}

/etc/init.d/mysql.server restart

: "----- check master status for start replication"
declare -r REPL_USER="repl"

declare -r MAS_INFO=$(echo 'SHOW MASTER STATUS' | ${MYSQL_CMD} -u ${REPL_USER} -p${REPL_PW} -h ${MASTER_HOST})
declare -r LOG_FILE=$(echo ${MAS_INFO} | awk '{print $6}')
echo "CURRENT_LOG_FILE=${LOG_FILE}"
declare -r LOG_POS=$(echo ${MAS_INFO} | awk '{print $7}')
echo "CURRENT_LOG_POS=${LOG_POS}"

: "----- initialize and start replication"
# Note: Before change master, run "show master status" and check "master_log_file" and "master_log_pos"
declare -r MASTER_LOG="mysql-bin.000001"

#${MYSQL_CMD} -u ${MYSQL_USER} -e "STOP SLAVE"
${MYSQL_CMD_LINE} -e "RESET SLAVE"
${MYSQL_CMD_LINE} << EOS
CHANGE MASTER TO
MASTER_HOST = '${MASTER_HOST}',
MASTER_USER = '${REPL_USER}',
MASTER_PASSWORD = '${REPL_PW}',
MASTER_LOG_FILE = '${MASTER_LOG}',
MASTER_LOG_POS = 0
EOS

: "----- confirm slave status (before)"
${MYSQL_CMD_LINE} -e "SHOW SLAVE STATUS \G"

: "----- start slave"
echo "START SLAVE"
${MYSQL_CMD_LINE} -e "START SLAVE"

: "----- confirm slave status (after)"
${MYSQL_CMD_LINE} -e "SHOW SLAVE STATUS \G"
