call plug#begin('~/.vim/plugged')

" Base16 colorscheme support
let base16colorspace=256
Plug 'danielwe/base16-vim', {'do': 'git checkout dict_fix'}
colorscheme base16-default-dark
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif

" Notetaking
Plug 'vimwiki/vimwiki'

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
let g:coc_global_extensions = ['coc-eslint', 'coc-json', 'coc-python', 'coc-rls', 'coc-java', 'coc-snippets']

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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

" Better js syntax support
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
 
" Plugin for working with quotes, brackets, tags, etc.
Plug 'tpope/vim-surround'

" Search/replace options
Plug 'tpope/vim-abolish'

" File search
Plug 'epmatsw/ag.vim'

" Save/load macros
Plug 'chamindra/marvim'

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
