return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master", -- ou "0.1.x" pour la stable
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
      "andrew-george/telescope-themes",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")
      local builtin   = require("telescope.builtin")

      -- charge les extensions
      telescope.load_extension("fzf")
      telescope.load_extension("themes")

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings     = { i = {}, n = {} },
        },
        extensions = {
          themes = {
            enable_previewer    = true,
            enable_live_preview = true,
          },
        },
      })

      -- Keymaps principaux
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>tt", "<cmd>Telescope themes<CR>",    { desc = "Theme Switcher" })
    end,
  },
}


