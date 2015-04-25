#!/bin/bash

### common prepare script. expect to be called `source prepare.sh`

set -eux

declare -r MYNAME=`basename $0`
declare -r MYDIR=$(cd $(dirname $0) && pwd)
declare -r MYUSER=$(whoami)

source ${MYDIR}/envs
