function border(hl_name)
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

-------------------------------------------------------------------------------
-- Colors
-------------------------------------------------------------------------------

vim.cmd("set termguicolors")
vim.cmd("set colorcolumn=100")
vim.cmd("highlight LineNr guifg=#657b83")
vim.cmd("highlight DiagnosticError guifg=#dc322f")
vim.cmd("highlight DiagnosticWarn guifg=#b58900")
vim.cmd("highlight DiagnosticUnderlineWarn guibg=#073642 cterm=none")
vim.cmd("highlight DiagnosticHint guifg=#2aa198")
vim.cmd("highlight DiagnosticUnderlineHint guibg=#073642 cterm=none")
vim.cmd("sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=")
vim.cmd("sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=")
vim.cmd("sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=")
vim.cmd("highlight DapStopped guibg=#073642")
vim.cmd("highlight DapBreakpoint guifg=#dc322f")

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
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"christoomey/vim-tmux-navigator", -- Interop with tmux pane switching
	"tpope/vim-fugitive", -- Git integration
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	"farmergreg/vim-lastplace", -- Persist cursor position
	"tpope/vim-surround", -- Additional text objects

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local actions = require("telescope.actions")

			require("telescope").setup({
				pickers = {
					find_files = {
						hidden = true,
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--hidden",
						"--glob=!.git/",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
			})
		end,
	},

	"rrethy/nvim-base16",
	{
		"feline-nvim/feline.nvim",
		dependencies = { { "kyazdani42/nvim-web-devicons" } },
		config = function()
			local solarized = {
				fg = "#abb2bf",
				bg = "#073642",
				green = "#859900",
				yellow = "#b58900",
				purple = "#c678dd",
				orange = "#d19a66",
				peanut = "#f6d5a4",
				red = "#dc322f",
				aqua = "#2aa198",
				darkblue = "#268bd2",
				dark_red = "#dc322f",
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
					provider = function(component)
						local filename = vim.api.nvim_buf_get_name(0)
						if filename == "" then
							filename = "[no name]"
						end
						filename = vim.fn.fnamemodify(filename, ":~:.")
						local icon = require("nvim-web-devicons").get_icon(filename, extension, { default = true })
						local extension = vim.fn.expand("%:e")
						if vim.bo.modified then
							modified_str = " ●"
						else
							modified_str = ""
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
				lsp_progress = {
					provider = function()
						local lsp = vim.lsp.util.get_progress_messages()[1]
						if lsp then
							local name = lsp.name or ""
							local msg = lsp.message or ""
							local percentage = lsp.percentage or 0
							local title = lsp.title or ""
							return string.format(" %%<%s: %s %s ", name, title, msg)
						end

						return ""
					end,
					hl = {
						fg = "gray",
					},
				},
			}
			require("feline").setup({
				theme = solarized,
				components = {
					active = {
						{ c.vim_mode, c.filename },
						{},
						{ c.lsp_progress, c.diagnostic_hints, c.diagnostic_warnings, c.diagnostic_errors, c.separator },
					},
					inactive = {
						{ c.filename },
						{},
						{ c.lsp_progress, c.diagnostic_hints, c.diagnostic_warnings, c.diagnostic_errors, c.separator },
					},
				},
			})
		end,
	},
	"dstein64/nvim-scrollview",

	-- LSP
	"neovim/nvim-lspconfig",

	-- Linting
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				markdown = { "vale" },
				ansible = { "ansible_lint" },
				javascript = { { "eslint_d", "eslint" } },
				typescript = { { "eslint_d", "eslint" } },
			}
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					javascript = { { "prettierd", "prettier" } },
					typescript = { { "prettierd", "prettier" } },
					go = { "gofmt" },
				},
			})
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip" },
		config = function()
			-- Configure LSP Servers
			local cmp = require("cmp")
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
				vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
			end

			local servers = { "rust_analyzer", "pyright", "tsserver" }
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			require("cmp").setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
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
					{ name = "git" },
					{ name = "buffer" },
					{ name = "path" },
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
	float = {
		border = border("DiagBorder"),
	},
})

vim.o.updatetime = 250
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]])
vim.cmd("colorscheme base16-solarized-dark")

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

vim.keymap.set("n", "<space>", function()
	require("dap").continue()
end)

vim.keymap.set("n", "<leader>r", ":source $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>p", ":PackerSync<CR>")
vim.keymap.set("n", "<leader>f", function()
	require("conform").format()
end)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
vim.keymap.set("v", "<leader>c", '"+y')
vim.keymap.set("n", "<leader>v", '"+p')
vim.keymap.set("n", "<leader>b", ":Git blame --date=relative<CR>")

-- Debugging
vim.keymap.set("n", "<leader>d", function()
	require("dapui").toggle()
end)
vim.keymap.set("n", "<leader>x", function()
	require("dap").toggle_breakpoint()
end)
