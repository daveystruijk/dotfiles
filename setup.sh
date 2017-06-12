#!/bin/sh

if ! xset q &>/dev/null; then
    HAS_GUI = 1
fi

# Set timezone
sudo timedatectl set-timezone Europe/Amsterdam

# Binaries
sudo apt-get -y install open-vm-tools open-vm-tools-desktop git vim tmux zsh dconf-tools dconf-cli silversearcher-ag

# Vim
if [ ! -d "$HOME/.vim_runtime" ]; then
    git clone https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
fi

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Link dotfiles
ln -srf my_configs.vim $HOME/.vim_runtime/my_configs.vim
ln -srf tmux.conf $HOME/.tmux.conf
ln -srf zshrc $HOME/.zshrc

# Git
git config --global user.email "mail@daveystruijk.com"
git config --global user.name "Davey Struijk"

if [ -n "$HAS_GUI" ]; then
    # Swap caps lock & escape keys
    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

    # Colorscheme
    git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git ./gnome-terminal-colors-solarized
    bash -c "./gnome-terminal-colors-solarized/install.sh -s dark -p Default --install-dircolors"
fi

