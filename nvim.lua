-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

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

require("packer").startup(function(use)
	-- Essentials
	use("wbthomason/packer.nvim")
	use("christoomey/vim-tmux-navigator")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- Git
	use("tpope/vim-fugitive")
	use({
		"lewis6991/gitsigns.nvim",
		tag = "release",
		config = function()
			require("gitsigns").setup()
		end,
	})

	-- Extended functionality
	use("farmergreg/vim-lastplace")
	use("tpope/vim-surround")

	use({
		"AckslD/nvim-neoclip.lua",
		requires = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("neoclip").setup()
		end,
	})

	-- UI
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
			})
		end,
	})
	use("rrethy/nvim-base16")
	use({
		"feline-nvim/feline.nvim",
		requires = { { "kyazdani42/nvim-web-devicons" } },
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
	})
	use("dstein64/nvim-scrollview")

	-- LSP / Completion
	use("neovim/nvim-lspconfig", {
		opts = {
			format = { timeout_ms = 10000 },
		},
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.code_actions.gitsigns,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.diagnostics.ansiblelint,
					null_ls.builtins.diagnostics.rubocop,
					null_ls.builtins.completion.tags,
				},
			})
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = { { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip" } },
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
	})

	-- Debugging
	use({
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			dap.defaults.fallback.external_terminal = {
				command = "tmux",
				args = { "split-pane" },
			}
			dap.adapters.python = {
				type = "executable",
				command = "/usr/local/bin/python3",
				args = { "-m", "debugpy.adapter" },
			}
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return "/usr/local/bin/python3"
					end,
					args = { "-m", "debugpy.adapter" },
				},
			}
		end,
	})
	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("dapui").setup()
		end,
	})
	use({
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	})
end)

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

-----------------------------------------------------------
-- Settings
-----------------------------------------------------------

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.number = true
vim.opt.signcolumn = "number"
vim.opt.showmatch = true
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.scrolloff = 4

-----------------------------------------------------------
-- Colors
-----------------------------------------------------------

vim.cmd("set termguicolors")
vim.cmd("colorscheme base16-solarized-dark")
vim.cmd("highlight LineNr guifg=#657b83")
vim.cmd("highlight DiagnosticError guifg=#dc322f")
vim.cmd("highlight DiagnosticWarn guifg=#b58900")
vim.cmd("highlight DiagnosticUnderlineWarn guibg=#073642 cterm=none")
vim.cmd("highlight DiagnosticHint guifg=#2aa198")
vim.cmd("highlight DiagnosticUnderlineHint guibg=#073642 cterm=none")
vim.cmd("sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=")
vim.cmd("sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=")
vim.cmd("sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=")

-----------------------------------------------------------
-- Key mappings
-----------------------------------------------------------

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<C-c>", "<cmd>noh<CR>")

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", telescope.find_files)
vim.keymap.set("n", "<C-f>", telescope.live_grep)
vim.keymap.set("n", "<C-e>", "<cmd>TroubleToggle<CR>")

-- Debugging
vim.keymap.set("n", "<space>", function()
	require("dap").continue()
end)

-----------------------------------------------------------
-- Leader mappings
-----------------------------------------------------------

vim.g.mapleader = ","
vim.keymap.set("n", "<leader>r", ":source $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>p", ":PackerSync<CR>")
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format({ timeout_ms = 20000 })
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
