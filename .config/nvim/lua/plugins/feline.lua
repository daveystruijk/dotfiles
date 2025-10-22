-- Statusbar
-- https://github.com/famiu/feline.nvim
return {
  "freddiehaddad/feline.nvim",
  dependencies = { { "kyazdani42/nvim-web-devicons" } },
  config = function()
    local colors = {
      fg = "#e5e5e5",
      bg = "#666666",
      green = "#0dbc79",
      yellow = "#e5e510",
      purple = "#bc3fbc",
      orange = "#e5e510",
      peanut = "#11a8cd",
      red = "#cd3131",
      aqua = "#2472c8",
      darkblue = "#11a8cd",
      dark_red = "#bc3fbc",
    }

    local c = {
      bg = {
        hl = {
          bg = "bg",
        },
      },
      filename = {
        name = "filename",
        hl = {
          bg = "darkblue",
          fg = "white",
        },
        provider = function(_)
          local filename = vim.api.nvim_buf_get_name(0)
          if filename == "" then
            filename = "[no name]"
          end
          filename = vim.fn.fnamemodify(filename, ":~:.")
          local extension = vim.fn.expand("%:e")
          local icon =
            require("nvim-web-devicons").get_icon(filename, extension, { default = true })
          local modified_str = ""
          if vim.bo.modified then
            modified_str = " ●"
          end
          return icon .. " " .. filename .. modified_str
        end,
        left_sep = "block",
        right_sep = "block",
      },
      vim_mode = {
        provider = {
          name = "vi_mode",
          opts = {
            show_mode_name = true,
          },
        },
        hl = function()
          return {
            fg = "black",
            bg = require("feline.providers.vi_mode").get_mode_color(),
            style = "bold",
            name = "NeovimModeHLColor",
          }
        end,
        left_sep = "block",
        right_sep = "block",
      },
      separator = {
        provider = " ",
      },
      diagnostic_errors = {
        provider = "diagnostic_errors",
        hl = {
          bg = "red",
          fg = "white",
        },
        right_sep = "block",
      },
      diagnostic_warnings = {
        provider = "diagnostic_warnings",
        hl = {
          bg = "yellow",
          fg = "white",
        },
        right_sep = "block",
      },
      diagnostic_hints = {
        provider = "diagnostic_hints",
        hl = {
          bg = "aqua",
          fg = "white",
        },
        right_sep = "block",
      },
    }
    require("feline").setup({
      theme = colors,
      components = {
        active = {
          { c.vim_mode, c.filename },
          {},
          { c.diagnostic_hints, c.diagnostic_warnings, c.diagnostic_errors, c.separator },
        },
        inactive = {
          { c.filename },
          {},
          { c.diagnostic_hints, c.diagnostic_warnings, c.diagnostic_errors, c.separator },
        },
      },
    })
  end,
}
