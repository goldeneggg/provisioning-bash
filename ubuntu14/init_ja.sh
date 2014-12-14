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
apt-get -y update
apt-get -y upgrade
apt-get -y install build-essential netcat nmap strace dnsutils traceroute tcpdump jwhois sysstat lsof sysv-rc-conf

# locale
apt-get -y install language-pack-ja
update-locale LANG=ja_JP.UTF-8

# timezone is JST
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
