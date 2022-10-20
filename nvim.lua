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
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})

	-- Extended functionality
	use("farmergreg/vim-lastplace")
	use("tpope/vim-surround")

	-- UI
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("rrethy/nvim-base16")
	use("feline-nvim/feline.nvim")
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
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

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
