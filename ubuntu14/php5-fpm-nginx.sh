#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# initial setup
bash ${MYDIR}/init_ja.sh

# install & initial setup php5-fpm
bash ${MYDIR}/php5-fpm.sh

# reconfigure nginx to use php processor
VHOST_PHP5_FPM=hogefpm.localdomain
VHOST_PHP5_FPM_CONF=${VHOST_PHP5_FPM}.conf
VHOST_PHP5_FPM_SAV=/etc/nginx/sites-available/${VHOST_PHP5_FPM_CONF}

## put test php file on document root
DOC_ROOT=/usr/share/nginx/html
VHOST_DOC_ROOT=${DOC_ROOT}/${VHOST_PHP5_FPM}
if [ ! -d ${VHOST_DOC_ROOT} ]
then
  mkdir -p ${VHOST_DOC_ROOT}
fi

COPY_TARGETS=(${VHOST_PHP5_FPM_SAV} ${VHOST_DOC_ROOT}/index.php)
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

## symlink vhost conf to sites-enabled
VHOST_PHP5_FPM_ENB=/etc/nginx/sites-enabled/${VHOST_PHP5_FPM_CONF}
if [ -L ${VHOST_PHP5_FPM_ENB} ]
then
  rm ${VHOST_PHP5_FPM_ENB}
fi 
ln -s ${VHOST_PHP5_FPM_SAV} ${VHOST_PHP5_FPM_ENB}

# restart nginx
/etc/init.d/nginx restart
