#!/bin/sh

# Binaries
brew install git vim python python-pip gdb curl p7zip-full

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
ln -sf "$(pwd)/config.fish" $HOME/.config/fish/config.fish
ln -sf "$(pwd)/wgetrc" $HOME/.wgetrc
ln -sf "$(pwd)/gdbinit" $HOME/.gdbinit

# Node.js w/ nvm
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
fi

# Git
git config --global user.email "mail@daveystruijk.com"
git config --global user.name "Davey Struijk"

# Simple per-project todo lists (using t)
git clone https://github.com/sjl/t.git ~/t
mkdir ~/todos
