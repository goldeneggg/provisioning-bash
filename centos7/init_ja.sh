#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Install initial packages and set config files
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`

# install default packages
yum -y update
yum -y install net-tools nmap-ncat strace bind-utils traceroute tcpdump jwhois sysstat lsof wget epel-release

# copy files
COPY_TARGETS=("/etc/locale.conf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# timezone is JST
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
