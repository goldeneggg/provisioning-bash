#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# install dependencies  *Note: required root priv
sudo bash ${MYDIR}/_ruby-rbenv-rails4-dep.sh

# install rails
bash ruby-rbenv-gems.sh rails
