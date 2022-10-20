-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

require("packer").startup(function(use)
	-- Essentials
	use("wbthomason/packer.nvim")
	use("christoomey/vim-tmux-navigator")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- Git
	use("lewis6991/gitsigns.nvim")

	-- Extended functionality
	use("farmergreg/vim-lastplace")
	use("tpope/vim-surround")

	-- UI
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("rrethy/nvim-base16")
	use({
		"feline-nvim/feline.nvim",
		config = function()
			local c = {
				bg = {
					hl = {
						bg = "darkblue",
					},
				},
				filename = {
					name = "filename",
					provider = function()
						local filename = vim.api.nvim_buf_get_name(0)
						if filename == "" then
							filename = "[no name]"
						end
						return vim.fn.fnamemodify(filename, ":~:.")
					end,
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
							fg = require("feline.providers.vi_mode").get_mode_color(),
							bg = "darkblue",
							style = "bold",
							name = "NeovimModeHLColor",
						}
					end,
					left_sep = "block",
					right_sep = "block",
				},
				gitDiffAdded = {
					provider = "git_diff_added",
					hl = {
						fg = "green",
						bg = "darkblue",
					},
					left_sep = "block",
					right_sep = "block",
				},
				gitDiffRemoved = {
					provider = "git_diff_removed",
					hl = {
						fg = "red",
						bg = "darkblue",
					},
					left_sep = "block",
					right_sep = "block",
				},
				gitDiffChanged = {
					provider = "git_diff_changed",
					hl = {
						fg = "fg",
						bg = "darkblue",
					},
					left_sep = "block",
					right_sep = "right_filled",
				},
				separator = {
					provider = "",
				},
				fileinfo = {
					provider = {
						name = "file_info",
						opts = {
							type = "relative-short",
						},
					},
					hl = {
						style = "bold",
					},
					left_sep = " ",
					right_sep = " ",
				},
				diagnostic_errors = {
					provider = "diagnostic_errors",
					hl = {
						fg = "red",
					},
				},
				diagnostic_warnings = {
					provider = "diagnostic_warnings",
					hl = {
						fg = "yellow",
					},
				},
				diagnostic_hints = {
					provider = "diagnostic_hints",
					hl = {
						fg = "aqua",
					},
				},
				diagnostic_info = {
					provider = "diagnostic_info",
				},
				lsp_client_names = {
					provider = "lsp_client_names",
					hl = {
						fg = "purple",
						bg = "darkblue",
						style = "bold",
					},
					left_sep = "left_filled",
					right_sep = "block",
				},
				file_type = {
					provider = {
						name = "file_type",
						opts = {
							filetype_icon = true,
							case = "titlecase",
						},
					},
					hl = {
						fg = "red",
						bg = "darkblue",
						style = "bold",
					},
					left_sep = "block",
					right_sep = "block",
				},
				file_encoding = {
					provider = "file_encoding",
					hl = {
						fg = "orange",
						bg = "darkblue",
						style = "italic",
					},
					left_sep = "block",
					right_sep = "block",
				},
				position = {
					provider = "position",
					hl = {
						fg = "green",
						bg = "darkblue",
						style = "bold",
					},
					left_sep = "block",
					right_sep = "block",
				},
			}
			require("feline").setup({
				components = {
					active = {
						{ c.vim_mode },
						{},
					},
					inactive = {
						{},
						{},
					},
				},
			})
			require("feline").winbar.setup({
				components = {
					active = {
						{ c.filename, c.gitDiffAdded, c.gitDiffRemoved, c.gitDiffChanged },
						{},
					},
					inactive = {
						{ c.filename, c.gitDiffAdded, c.gitDiffRemoved, c.gitDiffChanged },
						{},
					},
				},
			})
		end,
	})
	use("dstein64/nvim-scrollview")

	-- LSP / Completion
	use("neovim/nvim-lspconfig")
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
		requires = { { "hrsh7th/cmp-nvim-lsp" } },
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
					{ name = "git" },
					{ name = "nvim_lsp" },
				},
			})
		end,
	})
	use({
		"folke/trouble.nvim",
		requires = { { "kyazdani42/nvim-web-devicons" } },
	})
end)

vim.diagnostic.config({
	severity_sort = true,
	underline = false,
})

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
-- vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeFindFileToggle<CR>')
vim.keymap.set("n", "<C-e>", "<cmd>TroubleToggle<CR>")
-- vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>')
-- vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>')

-----------------------------------------------------------
-- Leader mappings
-----------------------------------------------------------

vim.g.mapleader = ","
vim.keymap.set("n", "<leader>r", ":source $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>p", ":PackerSync<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
vim.keymap.set("v", "<leader>c", '"+y')
vim.keymap.set("n", "<leader>v", '"+p')
