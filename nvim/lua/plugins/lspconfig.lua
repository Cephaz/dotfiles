return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")

			-- Fonction améliorée pour détecter l'environnement Poetry
			local venv_path = vim.fn.trim(vim.fn.system("poetry env info --path"))
			local python_path = venv_path .. "/bin/python"

			if venv_path ~= "" then
				lspconfig.pyright.setup({
					settings = {
						python = {
							pythonPath = python_path,
						},
					},
				})
			end

			-- Keymaps LSP (créés au moment où un serveur s'attache au buffer)
			local augroup = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = augroup,
				callback = function(ev)
					-- Buffer local mappings
					local opts = { buffer = ev.buf, silent = true }
					-- keymaps
					opts.desc = "Show LSP references"
					vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

					opts.desc = "Go to declaration (vsplit)"
					vim.keymap.set("n", "gD", function()
						vim.cmd("vsplit")
						vim.lsp.buf.declaration()
					end, opts)

					opts.desc = "Go to definition (vsplit)"
					vim.keymap.set("n", "gd", function()
						vim.cmd("vsplit")
						vim.lsp.buf.definition()
					end, opts)

					opts.desc = "Show LSP implementations"
					vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					opts.desc = "Show LSP type definitions"
					vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

					opts.desc = "See available code actions"
					vim.keymap.set({ "n", "v" }, "<leader>vca", function()
						vim.lsp.buf.code_action()
					end, opts)

					opts.desc = "Smart rename"
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					opts.desc = "Show buffer diagnostics"
					vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					opts.desc = "Show line diagnostics"
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					opts.desc = "Go to next error"
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
					end, opts)

					opts.desc = "Go to previous error"
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
					end, opts)

					opts.desc = "Show documentation for cursor"
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "Restart LSP"
					vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

					vim.keymap.set("i", "<C-h>", function()
						vim.lsp.buf.signature_help()
					end, opts)
				end,
			})

			-- Config dédiée à lua_ls
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})
		end,
	},
}
