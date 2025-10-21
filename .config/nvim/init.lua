local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.number = true -- enable line numbers
vim.opt.signcolumn = "number"
vim.opt.showmatch = true
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.scrolloff = 4
vim.g.mapleader = ","
vim.cmd("set termguicolors")

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Themes
  -- https://github.com/RRethy/base16-nvim
  "rrethy/nvim-base16",

  -- Theme (selenized)
  -- https://github.com/Mofiqul/vscode.nvim
  "Mofiqul/vscode.nvim",

  -- Interop with tmux pane switching
  -- https://github.com/christoomey/vim-tmux-navigator
  "christoomey/vim-tmux-navigator",

  -- Git integration
  -- https://github.com/tpope/vim-fugitive
  "tpope/vim-fugitive",

  -- Git changes in the sign column
  -- https://github.com/lewis6991/gitsigns.nvim
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- Additional text objects
  -- https://github.com/tpope/vim-surround
  "tpope/vim-surround",

  -- Persist cursor position
  -- https://github.com/farmergreg/vim-lastplace
  "farmergreg/vim-lastplace",

  -- Treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        highlight = {
          enable = true,
        },
      })
    end,
  },

  -- Telescope
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          -- Include hidden files live_grep
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
        },
        -- Include hidden files in find_files
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },

  -- Statusbar
  -- https://github.com/nvim-lualine/lualine.nvim

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },

  -- LSP configuration
  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
    },
  },

  -- Linting
  -- https://github.com/mfussenegger/nvim-lint
  -- {
  --   "mfussenegger/nvim-lint",
  --   config = function()
  --     require("lint").linters_by_ft = {
  --       ansible = { "ansible_lint" },
  --       javascript = { "eslint_d", "eslint" },
  --       typescript = { "eslint_d", "eslint" },
  --       python = { "ruff" },
  --     }
  --   end,
  -- },

  -- Formatting
  -- https://github.com/stevearc/conform.nvim
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff", "ruff_format" },
          javascript = { "prettierd", "prettier" },
          typescript = { "prettierd", "prettier" },
          typescriptreact = { "prettierd", "prettier" },
          go = { "gofmt" },
          rust = { "rustfmt" },
          sql = { "pg_format" },
        },
      })
    end,
  },

  -- Completion
  -- https://github.com/hrsh7th/nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(
          vim.lsp.handlers.hover,
          { border = border("HoverBorder") }
        ),
        ["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          { border = border("HelpBorder") }
        ),
      }

      local on_attach = function(_, bufnr)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
      end

      local servers = { "pyright", "ts_ls", "eslint", "lua_ls", "ruff" }
      for _, lsp in ipairs(servers) do
        vim.lsp.config(lsp, {
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = handlers,
        })
        vim.lsp.enable(lsp)
      end

      vim.lsp.config("rust_analyzer", {
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = { "ssr" }, -- features = ssr, for LSP support in leptos SSR functions
            },
            procMacro = {
              ignored = {
                leptos_macro = {
                  "server",
                },
              },
            },
          },
        },
      })
      vim.lsp.enable("rust_analyzer")

      require("cmp").setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        window = {
          completion = {
            border = border("CmpBorder"),
          },
          documentation = {
            border = border("DocBorder"),
          },
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "calc" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },
})

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  virtual_text = false,
  update_in_insert = false,
})

vim.o.winborder = "rounded"
vim.o.updatetime = 250
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]])

-------------------------------------------------------------------------------
-- Colors
-------------------------------------------------------------------------------

vim.cmd("colorscheme vscode")
vim.cmd("highlight LineNr guifg=#657b83")
vim.cmd("highlight DiagnosticError guifg=#dc322f")
vim.cmd("highlight DiagnosticWarn guifg=#b58900")
vim.cmd("highlight DiagnosticUnderlineWarn guibg=#073642 cterm=none")
vim.cmd("highlight DiagnosticHint guifg=#2aa198")
vim.cmd("highlight DiagnosticUnderlineHint guibg=#073642 cterm=none")
vim.cmd("sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=")
vim.cmd("sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=")
vim.cmd("sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=")

-------------------------------------------------------------------------------
-- Keymappings
-------------------------------------------------------------------------------

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<C-C>", "<cmd>nohlsearch<CR>")

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", telescope.find_files)
vim.keymap.set("n", "<C-f>", telescope.live_grep)
vim.keymap.set("n", "K", vim.lsp.buf.hover)

vim.keymap.set("n", "<leader>r", ":source $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>p", ":PackerSync<CR>")
vim.keymap.set("n", "<leader>f", function()
  require("conform").format()
end)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
vim.keymap.set("v", "<leader>c", '"+y')
vim.keymap.set("n", "<leader>v", '"+p')
vim.keymap.set("n", "<leader>b", ":Git blame --date=relative<CR>")
