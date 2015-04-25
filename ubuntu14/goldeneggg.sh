#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## 1 = github user
## 2 = github mail
declare -r GITHUB_USER=${1:?"must supply GITHUB_USER"}
declare -r GITHUB_MAIL=${2:?"must supply GITHUB_MAIL"}
echo "github user = ${GITHUB_USER}"
echo "github mail = ${GITHUB_MAIL}"

declare -r HOME_BIN=${HOME}/bin
mkdir -p ${HOME_BIN}

# install stow
declare -r STOW_VER="2.2.0"
declare -r STOW_TAR=stow-${STOW_VER}.tar.gz
curl -L http://ftp.gnu.org/gnu/stow/${STOW_TAR} -o ${STOW_TAR}
tar zxf ${STOW_TAR}
cd stow-${STOW_VER}
./configure --prefix=${HOME_BIN}
make
make install

# install keychain
declare -r KEYCHAIN_VER="2.8.0"
declare -r KEYCHAIN_TAR=keychain-${KEYCHAIN_VER}.tar.bz2
curl -L http://www.funtoo.org/distfiles/keychain/${KEYCHAIN_TAR} -o ${KEYCHAIN_TAR}
tar xjf ${KEYCHAIN_TAR}
cd keychain-${KEYCHAIN_VER}
cp keychain keychain.pod ${HOME_BIN}/

# setup dotfiles
cd ~
git clone https://github.com/goldeneggg/dotfiles.git
cd dotfiles
bash setup.sh -L --github-user ${GITHUB_USER} --github-mail ${GITHUB_MAIL}
