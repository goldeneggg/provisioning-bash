#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- install default packages"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} build-essential netcat nmap strace dnsutils traceroute tcpdump jwhois sysstat lsof

: "----- set location info (is ja, JP)"
${PRVENV_CMD_PKG_INS} language-pack-ja
update-locale LANG=ja_JP.UTF-8

rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
