
" TODO:
"

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/nvim-compe'
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
Plug 'ishan9299/nvim-solarized-lua'
Plug 'xiyaowong/nvim-transparent'
Plug 'dstein64/nvim-scrollview'
Plug 'tpope/vim-surround'
Plug 'rbgrouleff/bclose.vim'
Plug 'iberianpig/tig-explorer.vim'
Plug 'mhartington/formatter.nvim'
Plug 'norcalli/nvim-colorizer.lua'
call plug#end()

set termguicolors
set background=dark
colorscheme solarized
highlight GitGutterAdd guibg=#073642
highlight GitGutterChange guibg=#073642
highlight GitGutterChangeDelete guibg=#073642
highlight GitGutterDelete guibg=#073642
highlight Visual guifg=#b58900 guibg=background
highlight ScrollView guibg=LightCyan
highlight TSComment guifg=none

lua << EOF
local lspconfig = require('lspconfig')
lspconfig.dockerls.setup{}
lspconfig.tsserver.setup{}
lspconfig.pyright.setup{}
lspconfig.rls.setup {
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
}
local filetypes = {
  javascript = {'eslint'},
  javascriptreact = {'eslint'},
  typescript = {'eslint'},
  typescriptreact = {'eslint'},
}
local linters = {
  eslint = {
    sourceName = 'eslint',
    command = "./node_modules/.bin/eslint",
    args = {'--format', 'compact', '%filepath'},
    rootPatterns = {'.eslintrc', '.eslintrc.js'},
    debounce = 100,
    args = {
      "--stdin",
      "--stdin-filename",
      "%filepath",
      "--format",
      "json",
    },
    parseJson = {
      errorsRoot = "[0].messages",
      line = "line",
      column = "column",
      endLine = "endLine",
      endColumn = "endColumn",
      message = "${message} [${ruleId}]",
      security = "severity",
    };
    securities = {
      [1] = "error",
      [2] = "warning"
    }
  },
}

lspconfig.diagnosticls.setup {
  filetypes = vim.tbl_keys(filetypes),
  init_options = {
    filetypes = filetypes,
    linters = linters,
  }
}
require'lualine'.setup{
  options = {
    theme = 'solarized_dark',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {{'filename', path=1}},
    lualine_c = {require'lsp-status'.status},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', path=1}},
    lualine_x = {},
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
require'compe'.setup{
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    ultisnips = false;
    luasnip = false;
  };
}
require("transparent").setup{
  enable = true,
}
require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
        -- prettier
       function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
            stdin = true
          }
        end
    },
    typescript = {
        -- prettier
       function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
            stdin = true
          }
        end
    },
    rust = {
      -- Rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    }
  }
})
require'colorizer'.setup()
EOF

let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:scrollview_excluded_filetypes = ['NvimTree']

set undofile  " Persistent undo
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set number
set signcolumn=number
set updatetime=100
set colorcolumn=100
set ignorecase
set incsearch
set smartcase
set completeopt=menuone,noselect
set shortmess+=c
set scrolloff=1
set clipboard+=unnamedplus

autocmd BufEnter * lua require'completion'.on_attach()

map j gj
map k gk

nnoremap ; :
nnoremap <C-p> <cmd>Telescope find_files<CR>
nnoremap <C-o> <cmd>Telescope oldfiles<CR>
nnoremap <C-f> <cmd>Telescope live_grep<CR>
nnoremap <C-n> <cmd>NvimTreeToggle<CR>
nnoremap <C-c> <cmd>noh<CR>

" Leader
let mapleader = ","
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>p :PlugInstall<CR>
nnoremap <Leader>b :TigBlame<CR>
nnoremap <leader>f :Format<CR>

