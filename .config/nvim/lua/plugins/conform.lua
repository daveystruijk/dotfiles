-- Formatting
-- https://github.com/stevearc/conform.nvim
return {
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
}
