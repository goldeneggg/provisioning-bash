#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## 1 = timezone (Asia/Tokyo, Etc/UTC, etc...)
declare -r MY_TZ=${1:-"Asia/Tokyo"}
echo "MY_TZ = ${MY_TZ}"

${PRVENV_CMD_PKG_UPD}

: "----- set location info"
# copy files
declare -ar COPY_TARGETS=("/etc/locale.conf" "/etc/ld.so.conf.d/libc.conf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# timezone is JST
rm /etc/localtime
ln -s /usr/share/zoneinfo/${MY_TZ} /etc/localtime

: "----- install default packages"
# install default packages
## net-tools has been unavailable
#${PREENV_CMD_PKG_INS} net-tools nmap-ncat strace bind-utils traceroute tcpdump jwhois sysstat lsof wget epel-release
${PRVENV_CMD_PKG_INS} git nmap-ncat strace bind-utils traceroute tcpdump jwhois sysstat lsof wget epel-release
${PRVENV_CMD_PKG} groupinstall "Development Tools"
