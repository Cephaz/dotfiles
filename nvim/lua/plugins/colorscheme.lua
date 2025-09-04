return {
	-- Colorscheme Tokyo Night
	{
		"folke/tokyonight.nvim",
		lazy = false, -- Charger immédiatement
		priority = 1000, -- Charger en premier
		config = function()
			require("tokyonight").setup({
				style = "night", -- storm, moon, night, day
				transparent = false,
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					sidebars = "dark",
					floats = "dark",
				},
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
