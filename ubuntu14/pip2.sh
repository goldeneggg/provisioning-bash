#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- install pip"
# (required: install python2)
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user

: "----- setup pip PATH"
echo "envfile path = ${ENV_RC}"

declare -r USER_PYTHON_ROOT="${HOME}/.local"
declare -r USER_PYTHON_PATH=${USER_PYTHON_ROOT}/bin
export PATH=${USER_PYTHON_PATH}:${PATH}

echo "export USER_PYTHON_PATH=${USER_PYTHON_PATH}" >> ${ENV_RC}
echo 'export PATH=${USER_PYTHON_PATH}:$PATH' >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u
