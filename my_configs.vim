" Colorscheme
set background=dark
colorscheme solarized

" Fix keyboard input delay
set timeoutlen=1000 ttimeoutlen=0

" Toggle command with only one keypress
nnoremap ; :

" Autocomplete on C-l (insert mode)
inoremap <C-l> <C-x><C-l>

" Clear search results on C-l (normal mode)
noremap <C-l> :nohlsearch<CR>

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

" Configure CtrlP to use ag
if executable("ag")
	set grepprg=ag\ --nogroup\ --nocolor
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	map <leader>a :Ag!<space>
	map <leader>A :Ag! "<C-r>=expand('<cword>')<CR>"
endif
let g:ctrlp_map = '<c-p>'
let g:ctrlp_max_height = 30
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'


