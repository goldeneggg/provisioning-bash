#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- check npm"
if [ `which npm` ]
then
  echo "node.js is already installed"
else
  bash ${MYDIR}/ndenv.sh
fi

: "----- install yarn by alternative"
curl -o- -L https://yarnpkg.com/install.sh | bash

set +u; source ${ENV_RC}; set -u
yarn --version
