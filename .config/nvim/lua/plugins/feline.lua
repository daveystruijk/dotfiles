-- Statusbar
-- https://github.com/famiu/feline.nvim
return {
  "freddiehaddad/feline.nvim",
  dependencies = { { "kyazdani42/nvim-web-devicons" } },
  config = function()
    local colors = {
      fg = "#DCD7BA", -- fujiWhite
      bg = "#2A2A37", -- sumiInk4
      black = "#1F1F28", -- sumiInk3
      green = "#98BB6C", -- springGreen
      yellow = "#FF9E3B", -- roninYellow
      purple = "#957FB8", -- oniViolet
      orange = "#FFA066", -- surimiOrange
      peanut = "#658594", -- dragonBlue
      red = "#E82424", -- samuraiRed
      aqua = "#6A9589", -- waveAqua1
      darkblue = "#7E9CD8", -- crystalBlue
      dark_red = "#C34043", -- autumnRed
      skyblue = "#7FB4CA", -- springBlue
      oceanblue = "#7E9CD8", -- crystalBlue
      violet = "#957FB8", -- oniViolet
      cyan = "#7AA89F", -- waveAqua2
    }

    local vi_mode_colors = {
      NORMAL = "darkblue",
      OP = "darkblue",
      INSERT = "green",
      VISUAL = "purple",
      LINES = "purple",
      BLOCK = "purple",
      REPLACE = "orange",
      ["V-REPLACE"] = "orange",
      ENTER = "darkblue",
      MORE = "darkblue",
      SELECT = "skyblue",
      COMMAND = "yellow",
      SHELL = "green",
      TERM = "green",
      NONE = "aqua",
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
          bg = "#363646", -- sumiInk5
          fg = "#DCD7BA", -- fujiWhite
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
            fg = "#1F1F28", -- sumiInk3 (dark bg for contrast)
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
          bg = "#43242B", -- winterRed
          fg = "#E82424", -- samuraiRed
        },
        right_sep = "block",
      },
      diagnostic_warnings = {
        provider = "diagnostic_warnings",
        hl = {
          bg = "#49443C", -- winterYellow
          fg = "#FF9E3B", -- roninYellow
        },
        right_sep = "block",
      },
      diagnostic_hints = {
        provider = "diagnostic_hints",
        hl = {
          bg = "#252535", -- winterBlue
          fg = "#6A9589", -- waveAqua1
        },
        right_sep = "block",
      },
    }
    require("feline").setup({
      theme = colors,
      vi_mode_colors = vi_mode_colors,
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
