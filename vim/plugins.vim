call plug#begin('~/.vim/plugged')

" Base16 colorscheme support
Plug 'chriskempson/base16-vim'
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Integration with tmux panels (using <ctrl-[hjkl])
Plug 'christoomey/vim-tmux-navigator'

" Ctrl-P fuzzy file search
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" Autocompletion with coc.vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
let g:coc_global_extensions = ['coc-eslint', 'coc-tsserver', 'coc-json', 'coc-python', 'coc-rls']

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
endfunction

" Nerdtree (directory browser)
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
set encoding=UTF-8
nmap <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup nerdtree
    autocmd FileType nerdtree setlocal signcolumn=no modifiable
augroup END

function! FileIcon()
  return strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : ''
endfunction

function! LineInfo()
	return line('.') . '/' . line('$')
endfunction

" Nicer JSX indenting
Plug 'maxmellon/vim-jsx-pretty'
 
" Plugin for working with quotes, brackets, tags, etc.
Plug 'tpope/vim-surround'

" Tagbar with coc.vim support
Plug 'liuchengxu/vista.vim'
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
nmap <C-f> :Vista!!<CR>
let g:vista#renderer#enable_icon = 1
let g:vista_close_on_jump = 1

" Better status bar
Plug 'itchyny/lightline.vim'
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ ['fileicon', 'relativepath'],
      \             ['modified'] ],
      \   'right': [ ['lineinfo'], ['cocstatus'] ],
      \ },
      \ 'inactive': {
      \   'left': [ ['fileicon', 'relativepath'],
      \             ['modified'] ],
      \   'right': [ ['lineinfo'], ['cocstatus'] ],
      \ },
      \ 'component_function': {
      \   'fileicon': 'FileIcon',
      \   'lineinfo': "LineInfo",
      \   'cocstatus': "StatusDiagnostic",
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()  " When using Vista


call plug#end()
