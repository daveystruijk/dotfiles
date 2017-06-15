#!/bin/sh

for i in "$@"
do
case $i in
    --gui)
    HAS_GUI=1
    ;;
    *)
    ;;
esac
done

# Set timezone
timedatectl set-timezone Europe/Amsterdam

# Binaries
apt update
apt install -y zsh git vim tmux silversearcher-ag python python-pip gdb curl p7zip-full
if [ -n "$HAS_GUI" ]; then
    apt install -y open-vm-tools open-vm-tools-desktop dconf-tools dconf-cli
fi

# Vim
if [ ! -d "$HOME/.vim_runtime" ]; then
    git clone https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Link dotfiles
ln -sf "$(pwd)/my_configs.vim" $HOME/.vim_runtime/my_configs.vim
ln -sf "$(pwd)/plugins_config.vim" $HOME/.vim_runtime/vimrcs/plugins_config.vim
ln -sf "$(pwd)/tmux.conf" $HOME/.tmux.conf
ln -sf "$(pwd)/zshrc" $HOME/.zshrc
ln -sf "$(pwd)/wgetrc" $HOME/.wgetrc
ln -sf "$(pwd)/gdbinit" $HOME/.gdbinit

# Node.js w/ nvm
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
fi

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

