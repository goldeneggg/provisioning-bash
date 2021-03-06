#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## 1 = fastcgi_pass (= "IP:PORT")
declare -r FCGI_PASS=${1:-"unix:/var/run/php5-fpm.sock"}
echo "fastcgi_pass = ${FCGI_PASS}"

: "----- reconfigure nginx to use php processor"
declare -r VHOST_PHP5_FPM=hogefpm.localdomain
declare -r VHOST_PHP5_FPM_CONF=${VHOST_PHP5_FPM}.conf
declare -r VHOST_PHP5_FPM_SAV=/etc/nginx/sites-available/${VHOST_PHP5_FPM_CONF}

: "----- put test php file on document root"
declare -r DOC_ROOT=/usr/share/nginx/html
declare -r VHOST_DOC_ROOT=${DOC_ROOT}/${VHOST_PHP5_FPM}
[ -d ${VHOST_DOC_ROOT} ] || mkdir -p ${VHOST_DOC_ROOT}

declare -ar COPY_TARGETS=(${VHOST_PHP5_FPM_SAV} ${VHOST_DOC_ROOT}/index.php)
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

: "----- replace fastcgi_pass by argument content"
sed -i "s|@@FCGI_PASS@@|${FCGI_PASS}|g" ${VHOST_PHP5_FPM_SAV}

: "----- symlink vhost conf to sites-enabled"
declare -r VHOST_PHP5_FPM_ENB=/etc/nginx/sites-enabled/${VHOST_PHP5_FPM_CONF}
[ -L ${VHOST_PHP5_FPM_ENB} ] && rm ${VHOST_PHP5_FPM_ENB}
ln -s ${VHOST_PHP5_FPM_SAV} ${VHOST_PHP5_FPM_ENB}

/etc/init.d/nginx restart
