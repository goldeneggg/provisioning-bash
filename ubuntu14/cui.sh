#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- install packages for cui environment"
${PRVENV_CMD_PKG_INS} ncurses-term screen tmux git zsh ctags lv unzip stow ack-grep jq 
: "----- install latest ripgrep"
# See: https://github.com/phiresky/ripgrep-all#linux
${PRVENV_CMD_PKG_INS} ripgrep pandoc poppler-utils ffmpeg cargo
: "----- install latest vim"
add-apt-repository -y ppa:jonathonf/vim
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} vim

: "----- install latest neovim by appimage"
declare -r NVIM_PREFIX=/usr/local
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod +x nvim.appimage
mv nvim.appimage ${NVIM_PREFIX}/bin/nvim
