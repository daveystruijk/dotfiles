source ~/dotfiles/vim/plugins.vim

" Highlight current line
set cursorline

" Fix keyboard input delay
set timeoutlen=1000 ttimeoutlen=0

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

syntax enable