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

" Don't do folding
autocmd FileType * exe "normal zi"

" Tempfix for most files
set shiftwidth=2
set tabstop=2
set expandtab

set colorcolumn=100

nnoremap <esc> :noh<return><esc>

" The Silver Searcher
if executable('ag')
	" Use ag over grep
	set grepprg=ag\ --nogroup\ --nocolor
	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

syntax enable
