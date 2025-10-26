-- Completion
-- https://github.com/hrsh7th/nvim-cmp
return {
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
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help),
    }

    local on_attach = function(_, bufnr)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
    end

    local servers = { "pyright", "ts_ls", "eslint", "ruff", "jsonls" }
    for _, lsp in ipairs(servers) do
      vim.lsp.config(lsp, {
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
      })
      vim.lsp.enable(lsp)
    end

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")

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
      sources = {
        { name = "nvim_lsp" },
        { name = "calc" },
        { name = "path" },
        { name = "buffer" },
      },
    })
  end,
}
