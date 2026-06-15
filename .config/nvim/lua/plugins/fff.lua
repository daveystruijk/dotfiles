-- fff.nvim - fast fuzzy file picker
-- https://github.com/dmtrKovalenko/fff.nvim
return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  opts = {
    hl = {
      normal = "Normal",
      border = "FFFBorder",
      title = "Title",
    },
    grep = {
      location_format = ":%d", -- line number only, no column
    },
  },
  config = function(_, opts)
    -- Border keeps FloatBorder's foreground but uses Normal's background,
    -- so it blends with the picker body. Re-applied on colorscheme change.
    local function set_border_hl()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      local border = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
      vim.api.nvim_set_hl(0, "FFFBorder", { fg = border.fg, bg = normal.bg })
    end

    set_border_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_border_hl })
    require("fff").setup(opts)
  end,
}
