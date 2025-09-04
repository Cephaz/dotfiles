return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- javascript = { "biome-check" },
				-- typescript = { "biome-check" },
				-- javascriptreact = { "biome-check" },
				-- typescriptreact = { "biome-check" },
				--             css = { "biome-check" },
				--             html = { "biome-check" },
				-- svelte = { "prettier" },
				-- json = { "prettier" },
				-- yaml = { "prettier" },
				-- graphql = { "prettier" },
				-- liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				-- markdown = { "prettier" , "markdown-toc" },
				-- ["markdown.mdx"] = { "prettier", "markdownlint", "markdown-toc" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})
	end,
}
