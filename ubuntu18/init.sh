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

: "----- setup timezone"
DEBIAN_FRONTEND=noninteractive ${PRVENV_CMD_PKG_INS} tzdata
rm /etc/localtime
ln -s /usr/share/zoneinfo/${MY_TZ} /etc/localtime

: "----- setup lang and locale"
DEBIAN_FRONTEND=noninteractive ${PRVENV_CMD_PKG_INS} language-pack-${MY_LOCALE}
update-locale LANG=${MY_LANG}

: "----- install default packages"
${PRVENV_CMD_PKG_INS} git build-essential strace sysstat lsof daemontools gdb gdbserver gdebi autoconf
