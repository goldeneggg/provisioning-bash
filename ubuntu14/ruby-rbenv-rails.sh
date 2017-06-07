#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

sudo -E bash ${MYDIR}/_ruby-rbenv-rails4-dep.sh

bash ruby-rbenv-gems.sh rails
