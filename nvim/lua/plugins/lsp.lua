return {
	-- Configuration LSP de base
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Configuration pour Lua avec Neovim
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								"vim",
								"require",
							},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = {
								vim.env.VIMRUNTIME,
								-- Typing is ON, it will load all lua files under ~/.config/nvim to get types
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
							maxPreload = 100000,
							preloadFileSize = 10000,
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})
		end,
	},

	-- Mason LSP Config
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls", -- Lua Language Server
			},
			automatic_installation = true,
		},
	},
}
