
" TODO:
"

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'christoomey/vim-tmux-navigator'  " ctrl-[hjkl] including tmux
Plug 'farmergreg/vim-lastplace'
Plug 'lewis6991/gitsigns.nvim'
Plug 'overcache/NeoSolarized'
call plug#end()

colorscheme NeoSolarized
highlight GitGutterAdd guibg=#073642
highlight GitGutterChange guibg=#073642
highlight GitGutterChangeDelete guibg=#073642
highlight GitGutterDelete guibg=#073642
highlight Visual guifg=#b58900 guibg=background

lua << EOF
local lspconfig = require('lspconfig')
lspconfig.dockerls.setup{}
lspconfig.tsserver.setup{}
lspconfig.rls.setup {
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
}
lspconfig.diagnosticls.setup{}
require'lualine'.setup{
  options = {
    theme = 'solarized_dark',
  },
  tabline = {
    lualine_a = {require'lsp-status'.status},
    lualine_b = {},
    lualine_y = {'branch'}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {{'filename', path=1}},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'progress'},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', path=1}},
    lualine_x = {'progress'},
    lualine_y = {},
    lualine_z = {}
  },
}
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
}
local actions = require('telescope.actions')
require'telescope'.setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-c>"] = actions.close,
      },
    },
  }
}
require('gitsigns').setup{
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
}

EOF

set termguicolors  " True colors
set undofile  " Persistent undo
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set number
set signcolumn=number
set updatetime=100
set cursorline

nnoremap ; :
nnoremap <C-p> <cmd>Telescope find_files<CR>
nnoremap <C-f> <cmd>Telescope live_grep<CR>
nnoremap <C-n> <cmd>NvimTreeToggle<CR>
nnoremap <c-c> <cmd>noh<CR>

" Leader
let mapleader = ","
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>p :PlugInstall<CR>

