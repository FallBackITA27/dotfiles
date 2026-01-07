return {
	"morhetz/gruvbox",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("html", {})
			vim.lsp.config("cssls", {})
			vim.lsp.config("ts_ls", {})
			vim.lsp.config("clangd", {})
			vim.lsp.config("emmet_language_server", {
				capabilities = capabilities,
				filetypes = {
					"html",
				},
			})

			vim.lsp.enable({
				"ts_ls",
				"html",
				"cssls",
				"emmet_language_server",
				"clangd",
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},

	{ "hrsh7th/cmp-nvim-lsp", lazy = true, event = "InsertEnter" },
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"f3fora/cmp-spell",
			"windwp/nvim-autopairs",
			"L3MON4D3/LuaSnip",
			-- 'quangnguyen30192/cmp-nvim-ultisnips',
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"onsails/lspkind.nvim",
			"saadparwaiz1/cmp_luasnip",
			-- {'tzachar/cmp-tabnine', build='./install.sh', lazy = true, event = "InsertEnter"},
		},
		config = function()
			local lspkind = require("lspkind")
			lspkind.init()
			local cmp = require("cmp")
			local select_opts = { behavior = cmp.SelectBehavior.Select }
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				completion = {},
				snippet = {
					expand = function(args)
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						require("luasnip").lsp_expand(args.body)
					end,
				},
				reselect = cmp.PreselectMode.None,
				mapping = {
					-- ... Your other mappings ...
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					-- ['<esc>'] = cmp.mapping.abort()
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp_signature_help" },
					-- { name = "codeium" },
					{ name = "path" },
					{ name = "nvim_lsp", keyword_length = 2 },
					-- { name = 'ultisnips' },
					-- { name = 'cmp_tabnine' },
					{ name = "luasnip" },
				}, { { name = "buffer", keyword_length = 3 }, { name = "spell" } }),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
						symbol_map = { Codeium = "" },
					}),
				},
				experimental = {
					ghost_text = true,
				},
			})

			vim.lsp.config("emmet_language_server", {
				capabilities = capabilities,
				filetypes = {
					"html",
				},
			})

			vim.lsp.enable({
				"ts_ls",
				"html",
				"cssls",
				"emmet_language_server",
			})

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.0",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"olrtg/nvim-emmet",
		config = function()
			vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
		end,
	},
}
