source ~/dotfiles/vim/sensible.vim
source ~/dotfiles/vim/plugins.vim

let mapleader = ','

" Persistent undo
set undofile
set undodir=~/.vim/undodir
set noswapfile

" Always show sign column
set signcolumn=yes

" Reload vimr configuration file
nnoremap <Leader>r :source $MYVIMRC<CR>

" Highlight current line
set cursorline

" Highlight search results while typing
set hlsearch
set incsearch

" Case insensitive search (smart)
set ignorecase
set smartcase

" Toggle command with only one keypress
nnoremap ; :

" Infer casing when doing a search/replace
set infercase

" Improve performance for files with long lines
set synmaxcol=500

" j and k through long lines as if they were seperate
map j gj
map k gk

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Tempfix for most files
set shiftwidth=2
set tabstop=2
set expandtab

" Soft character limit of limit of 100
set colorcolumn=100

nnoremap <c-c> :noh<return><esc>

if exists('$TMUX')
  autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
  autocmd VimLeave * call system("tmux setw automatic-rename")
endif

set splitbelow
set splitright

set updatetime=100

set cinoptions=l1
