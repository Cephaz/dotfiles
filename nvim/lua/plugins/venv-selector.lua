return {
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("venv-selector").setup({
				cache_dir = vim.fn.stdpath("cache") .. "/venv-selector",
				cache_enabled = true,

				-- Utilise Poetry, avec fallback sur ./.venv
				search = {
					{
						name = "poetry",
						-- IMPORTANT: la clé correcte est `command`
						command = "poetry env info --path 2>/dev/null",
					},
					{
						name = "venv-local",
						pattern = "./.venv",
					},
				},

				auto_reload = true,
			})
		end,
		keys = {
			{ "<leader>pv", "<cmd>VenvSelect<CR>", desc = "Python: choisir un venv" },
			{ "<leader>pV", "<cmd>VenvSelectCached<CR>", desc = "Python: reprendre le dernier venv" },
		},
	},
}
