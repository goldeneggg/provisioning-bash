#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- install many useful network utilities"
# See: http://www.binarytides.com/linux-commands-monitor-network/
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} netcat nmap dnsutils traceroute tcpdump jwhois nload iftop vnstat speedometer pktstat ifstat dstat
