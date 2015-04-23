#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# install default packages
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG} upgrade
${PRVENV_CMD_PKG_INS} build-essential netcat nmap strace dnsutils traceroute tcpdump jwhois sysstat lsof sysv-rc-conf

# locale
${PRVENV_CMD_PKG_INS} language-pack-ja
update-locale LANG=ja_JP.UTF-8

# timezone is JST
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
