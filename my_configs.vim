" Colorscheme
set background=dark
colorscheme solarized

" Fix keyboard input delay
set timeoutlen=1000 ttimeoutlen=0

" Toggle command with only one keypress
nnoremap ; :

" Autocomplete on C-l (insert mode)
inoremap <C-l> <C-x><C-l>

" Infer casing when doing a search/replace
set infercase

" Improve performance for files with long lines
set synmaxcol=200

" Press Q in visual line mode to run @q over each line
xnoremap Q :'<,'>:normal @q<CR>

" j and k through long lines as if they were seperate
map j gj
map k gk

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

