#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## 1 = locale (ja, en, etc...)
## 2 = lang (ja_JP.UTF-8, en_US.UTF-8, etc...)
## 3 = timezone (Asia/Tokyo, Etc/UTC, etc...)
declare -r MY_LOCALE=${1:-"ja"}
declare -r MY_LANG=${2:-"ja_JP.UTF-8"}
declare -r MY_TZ=${3:-"Asia/Tokyo"}
echo "MY_LOCALE = ${MY_LOCALE}"
echo "MY_LANG = ${MY_LANG}"
echo "MY_TZ = ${MY_TZ}"

${PRVENV_CMD_PKG_UPD}

: "----- set location info"
${PRVENV_CMD_PKG_INS} language-pack-${MY_LOCALE}
update-locale LANG=${MY_LANG}

rm /etc/localtime
ln -s /usr/share/zoneinfo/${MY_TZ} /etc/localtime

: "----- install default packages"
# TODO grub-pc のupgradeでinteractiveにY/nを問われるのと、そもそもupgradeはサーバ構築完了後手動でやるべきな気がしてコメントアウト
#${PRVENV_CMD_PKG} upgrade
${PRVENV_CMD_PKG_INS} git build-essential netcat nmap strace dnsutils traceroute tcpdump jwhois sysstat lsof sysv-rc-conf
