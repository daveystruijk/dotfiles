#!/bin/sh

# Binaries
brew install git vim python python-pip gdb curl neovim alacritty tmux

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Link dotfiles
ln -sf "$(pwd)/tmux.conf" $HOME/.tmux.conf
ln -sf "$(pwd)/zshrc" $HOME/.zshrc
ln -sf "$(pwd)/wgetrc" $HOME/.wgetrc
ln -sf "$(pwd)/gdbinit" $HOME/.gdbinit
ln -sf "$(pwd)/alacritty.yml" $HOME/.alacritty.yml

# Git
git config --global user.email "mail@daveystruijk.com"
git config --global user.name "Davey Struijk"

