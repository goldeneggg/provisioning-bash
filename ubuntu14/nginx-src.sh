#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Setup nginx(src) environment
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

# prepare dependency
bash ${MYDIR}/init_ja.sh

# download nginx
MAJOR_VER="1.6"
MINOR_VER="2"
VER=${MAJOR_VER}.${MINOR_VER}
TAR=nginx-${VER}.tar.gz

cd ~
if [ -f ${TAR} ]
then
  rm -f ${TAR}
fi
${WGETCMD} http://nginx.org/download/${TAR}

# install dependencies
bash ${MYDIR}/nginx-src-dep.sh

# un-archive
if [ -d nginx-${VER} ]
then
  rm -fr nginx-${VER}
fi
tar zxf ${TAR}

# make, install
## http://wiki.nginx.org/InstallOptions
cd nginx-${VER}
./configure --with-http_ssl_module
make
make install

# create upstart config
COPY_TARGETS=("/etc/init/nginx.conf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# start by upstart
initctl start nginx
