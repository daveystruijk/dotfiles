
" TODO:
" - view current file but w/ git history 

" Plugins
call plug#begin('~/.vim/plugged')

" Essential
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'neovim/nvim-lspconfig'
Plug 'christoomey/vim-tmux-navigator'

" UI
Plug 'xiyaowong/nvim-transparent'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'overcache/NeoSolarized'
Plug 'hoob3rt/lualine.nvim'
Plug 'dstein64/nvim-scrollview'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim'
Plug 'f-person/git-blame.nvim'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'mhartington/formatter.nvim'

" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'iberianpig/tig-explorer.vim'

" Language-specific
Plug 'simrat39/rust-tools.nvim'

" Extended functionality
Plug 'tpope/vim-surround'
Plug 'farmergreg/vim-lastplace'
Plug 'folke/trouble.nvim'

" Writing
Plug 'folke/zen-mode.nvim'
Plug 'preservim/vim-pencil'

call plug#end()

set termguicolors
colorscheme NeoSolarized
highlight GitSignsAdd guibg=None
highlight GitSignsChange guibg=None
highlight GitSignsChangeDelete guibg=None
highlight GitSignsDelete guibg=None
highlight ScrollView guibg=LightCyan
highlight CursorLine guibg=#073642

set completeopt=menu,menuone,noselect

lua << EOF

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1
      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

vim.diagnostic.config({
    underline = true,
    signs = true,
    virtual_text = false,
    float = {
        show_header = false,
        source = 'if_many',
        border = 'rounded',
        focusable = false,
    },
    update_in_insert = false, -- default to false
    severity_sort = true, -- default to false
})
vim.cmd([[au CursorHold * lua vim.diagnostic.open_float(0,{scope = "cursor"})]])

require('bufferline').setup {
  options = {
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = ""
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " "
          or (e == "warning" and " " or "" )
        s = s .. n .. sym
      end
      return "(" .. s .. ")"
    end,
    offsets = {{
      filetype = "NvimTree",
      text = "",
    }},
    show_buffer_close_icons = false,
    show_close_icon = false,
    sort_by = 'relative_directory',
  }
}

require("zen-mode").setup {
  window = {
    width=66,
  }
}

vim.g.gitblame_message_template = '<date> • <author> • <summary>'
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
vim.g.gitblame_date_format = '%Y-%m-%d'

local git_blame = require('gitblame')

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lspconfig = require('lspconfig')

local opts = { noremap=true, silent=true }

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
end

lspconfig.dockerls.setup{
  capabilities = capabilities,
}
lspconfig.pyright.setup{
  capabilities = capabilities,
}
lspconfig.tsserver.setup{
  capabilities = capabilities,
  on_attach = on_attach,
}
lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
        },
      cargo = {
        loadOutDirsFromCheck = true
        },
      procMacro = {
      enable = true
      },
    }
  }
})

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
  capabilities = capabilities,
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
    lualine_c = {{git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available}},
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
require'nvim-treesitter.configs'.setup {}
local actions = require('telescope.actions')
require'telescope'.setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-c>"] = actions.close,
        ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
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
require("transparent").setup{
  enable = true,
}
local prettier_fn = {
 function()
    return {
      exe = "prettier",
      args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
      stdin = true
    }
  end
}
require('formatter').setup({
  logging = false,
  filetype = {
    lsp_markdown = prettier_fn,
    html = prettier_fn,
    yaml = prettier_fn,
    toml = prettier_fn,
    javascript = prettier_fn,
    javascriptreact = prettier_fn,
    typescript = prettier_fn,
    typescriptreact = prettier_fn,
    rust = {
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
    python = {
      function()
        return {
          exe = "python3",
          args = {"-m black ", vim.api.nvim_buf_get_name(0)},
          stdin = false
        }
      end
    }
  }
})
require'rust-tools'.setup()

require'nvim-tree'.setup {
  ignore_ft_on_setup  = {},
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}

require("trouble").setup {}

EOF

let g:scrollview_excluded_filetypes = ['NvimTree']

let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
augroup pencil
  autocmd!
  autocmd FileType tex call pencil#init()
augroup END

au BufReadPost *.svelte set syntax=html

set undofile  " Persistent undo
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set number
set signcolumn=number
set updatetime=100
set ignorecase
set incsearch
set smartcase
set shortmess+=c
set scrolloff=4
set cursorline

map j gj
map k gk

nnoremap <S-Tab> <cmd>BufferLineCyclePrev<CR>
nnoremap <Tab> <cmd>BufferLineCycleNext<CR>

nnoremap ; :
nnoremap <C-p> <cmd>Telescope find_files<CR>
nnoremap <C-f> <cmd>Telescope live_grep<CR>
nnoremap <C-n> <cmd>NvimTreeFindFileToggle<CR>
nnoremap <C-e> <cmd>TroubleToggle<CR>
nnoremap <C-c> <cmd>noh<CR>

nnoremap gb <cmd>GitBlameOpenCommitURL<CR>

" Leader
let mapleader = ","
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>p :PlugInstall<CR>
nnoremap <Leader>b :TigBlame<CR>
nnoremap <leader>f :Format<CR>
vnoremap <leader>c "+y
nnoremap <leader>v "+p

" Custom Silent command that will call redraw
command! -nargs=+ Silent
\   execute 'silent ! <args>'
\ | redraw!

map <leader>w :!pdflatex --interaction=nonstopmode '%'<CR><CR>

