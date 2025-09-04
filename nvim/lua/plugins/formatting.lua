return {
	-- Formatage avec conform.nvim
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			-- Définir les formatters par type de fichier
			formatters_by_ft = {
				lua = { "stylua" },
				-- On ajoutera d'autres langages plus tard
				-- python = { "ruff_format" },
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- vue = { "prettier" },
			},

			-- Format automatique à la sauvegarde
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},

			-- Installer automatiquement les formatters manquants
			format_after_save = {
				lsp_fallback = true,
			},
		},
		init = function()
			-- Si vous voulez format sur save pour certains types seulement
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	-- Linting avec nvim-lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- Définir les linters par type de fichier
			lint.linters_by_ft = {
				lua = { "luacheck" },
				-- On ajoutera d'autres langages plus tard
				-- python = { "ruff" },
				-- javascript = { "eslint_d" },
				-- typescript = { "eslint_d" },
			}

			-- Auto-lint sur certains événements
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- Mason pour installer automatiquement les outils
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- Formatters
				"stylua", -- Lua formatter

				-- Linters
				"luacheck", -- Lua linter

				-- On ajoutera plus d'outils plus tard selon vos langages
				-- "prettier",    -- JS/TS/Vue formatter
				-- "eslint_d",    -- JS/TS linter
				-- "ruff",        -- Python linter/formatter
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")

			-- Auto-installation des outils manquants
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end

			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}
