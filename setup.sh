#!/bin/sh

sudo timedatectl set-timezone Europe/Amsterdam

# Make caps lock behave like escape
if [ ! -f "$HOME/.xmodmaprc" ]; then
    cp xmodmaprc .xmodmaprc
fi

# Binaries
sudo apt-get -y install open-vm-tools open-vm-tools-desktop git vim tmux zsh

# Vim
if [ ! -d "$HOME/.vim_runtime" ]; then
    git clone https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
fi
if [ ! -f "$HOME/.vim_runtime/my_configs.vim" ]; then
    cp my_configs.vim $HOME/.vim_runtime/my_configs.vim
fi

# Tmux
if [ ! -f "$HOME/.tmux.conf" ]; then
    cp tmux.conf $HOME/.tmux.conf
fi

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"


