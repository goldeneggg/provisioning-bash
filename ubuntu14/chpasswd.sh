#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- change password for ubuntu user"
echo "ubuntu:ubuntu" | chpasswd
