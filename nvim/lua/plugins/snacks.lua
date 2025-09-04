return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- Core performance optimization
    bigfile = { enabled = true, size = 1.5 * 1024 * 1024 },
    quickfile = { enabled = true },
    
    -- Unified fuzzy finding and navigation
    picker = {
      enabled = true,
      ui_select = true,
      win = {
        input = {
          keys = {
            ["<a-h>"] = { "toggle_hidden", mode = { "n", "i" } },
            ["<a-i>"] = { "toggle_ignored", mode = { "n", "i" } },
            ["<a-p>"] = { "toggle_preview", mode = { "n", "i" } },
          },
        },
      },
      layout = { preset = "ivy", preview = true },
    },
    
    -- Project-aware file exploration
    explorer = { enabled = true, replace_netrw = true },
    
    -- Multi-language indentation support
    indent = {
      enabled = true,
      animate = { enabled = vim.fn.has("nvim-0.10") == 1 },
    },
    
    -- Development environment enhancements
    dashboard = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    lazygit = { configure = true },
    words = { enabled = true },
    scope = { enabled = true },
  },
  
  keys = {
    -- Core navigation
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    
    -- LSP integration for multi-language support
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Definitions" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Implementations" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
    
    -- Git operations
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    
    -- Project management
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<leader>t", function() Snacks.terminal() end, desc = "Terminal" },
  },
}

