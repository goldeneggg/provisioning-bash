#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# install pip
# (required: install python2)
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
