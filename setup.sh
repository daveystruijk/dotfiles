#!/bin/sh

sudo timedatectl set-timezone Europe/Amsterdam

# Binaries
sudo apt-get -y install open-vm-tools open-vm-tools-desktop git vim tmux zsh dconf-tools dconf-cli silversearcher-ag

dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

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

# Zsh
cp zshrc $HOME/.zshrc

# Git
git config --global user.email "mail@daveystruijk.com"
git config --global user.name "Davey Struijk"

# Colorscheme
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git ./gnome-terminal-colors-solarized
bash -c "./gnome-terminal-colors-solarized/install.sh -s dark -p Default --install-dircolors"
