curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo 'source ~/dotfiles/vimrc' >> ~/.vimrc

mkdir -p ~/.config/nvim
echo 'source ~/dotfiles/nvimrc' > ~/.config/nvim/init.vim

