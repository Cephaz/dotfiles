return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- Core performance optimization
    bigfile = { enabled = true, size = 1.5 * 1024 * 1024 },
    quickfile = { enabled = true },

    -- Unified fuzzy finding and navigation
    picker = {
      enabled = true,
      ui_select = true,
      layout = { preset = 'ivy', preview = true },
    },

    -- Project-aware file exploration
    explorer = { enabled = true, replace_netrw = true },

    -- Multi-language indentation support
    indent = {
      enabled = true,
      animate = { enabled = vim.fn.has('nvim-0.10') == 1 },
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
    {
      '<leader><space>',
      function()
        require('snacks').picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>,',
      function()
        require('snacks').picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>/',
      function()
        require('snacks').picker.grep()
      end,
      desc = 'Grep',
    },
    -- LSP integration for multi-language support
    {
      'gd',
      function()
        require('snacks').picker.lsp_definitions()
      end,
      desc = 'Definitions',
    },
    {
      'gr',
      function()
        require('snacks').picker.lsp_references()
      end,
      desc = 'References',
    },
    {
      'gI',
      function()
        require('snacks').picker.lsp_implementations()
      end,
      desc = 'Implementations',
    },
    {
      '<leader>ss',
      function()
        require('snacks').picker.lsp_symbols()
      end,
      desc = 'Document Symbols',
    },
    -- Git operations
    {
      '<leader>gb',
      function()
        require('snacks').picker.git_branches()
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>gg',
      function()
        require('snacks').lazygit()
      end,
      desc = 'Lazygit',
    },
    -- Project management
    {
      '<leader>e',
      function()
        require('snacks').explorer()
      end,
      desc = 'File Explorer',
    },
    {
      '<leader>t',
      function()
        require('snacks').terminal()
      end,
      desc = 'Terminal',
    },
  },
}
