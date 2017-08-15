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

: "----- install stow for dotfiles setup"
declare -r STOW_VER="2.2.2"
declare -r STOW_TAR=stow-${STOW_VER}.tar.gz

pushd ${PRVENV_INSTALL_WORK_DIR}
curl -L http://ftp.gnu.org/gnu/stow/${STOW_TAR} -o ${STOW_TAR}
tar zxf ${STOW_TAR}

pushd stow-${STOW_VER}
./configure --prefix=${HOME}
make
make install
popd

: "----- install kehchain for ssh-agent over {tmux,screen} sessions"
declare -r KEYCHAIN_VER="2.8.3"
declare -r KEYCHAIN_TAR=keychain-${KEYCHAIN_VER}.tar.bz2
curl -L http://www.funtoo.org/distfiles/keychain/${KEYCHAIN_TAR} -o ${KEYCHAIN_TAR}
tar xjf ${KEYCHAIN_TAR}

pushd keychain-${KEYCHAIN_VER}
declare -r HOME_BIN=${HOME}/bin
mkdir -p ${HOME_BIN}
cp keychain keychain.pod ${HOME_BIN}/
popd

export PATH=${HOME_BIN}:${PATH}

: "----- install npm packages"
if [ `which npm` ]
then
  declare -ar NPM_PKGS=("diff-so-fancy" "hubot")
  for pkg in ${NPM_PKGS[@]}
  do
    npm install -g ${pkg}
  done
fi

: "----- setup my dotfiles"
pushd ~
[ -d dotfiles ] || git clone https://github.com/goldeneggg/dotfiles.git

pushd dotfiles
git pull --rebase origin master
bash setup.sh -L --github-user ${GITHUB_USER} --github-mail ${GITHUB_MAIL}
