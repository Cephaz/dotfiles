return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          -- { section = "keys", gap = 1, padding = 1 },
          -- { section = "startup" },
          { section = "recent_files", title = "Fichiers récents", padding = 1 },
          { section = "projects", title = "Projets", padding = 1 },
        },
      },
      notifier = { enabled = true }, 
      bigfile = { enabled = true },  
      quickfile = { enabled = true }, 
    },
    keys = {
      { "<leader>d", function() Snacks.dashboard.open() end, desc = "Ouvrir le Dashboard" },
    },
  },
}
