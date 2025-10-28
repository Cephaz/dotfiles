return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- Core performance optimization
    bigfile = { enabled = true, size = 1.5 * 1024 * 1024 },
    quickfile = { enabled = true },

    -- HACK: read picker docs @ https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
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
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
    },
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
      '<leader>ff',
      function()
        require('snacks').picker.files()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>fb',
      function()
        require('snacks').picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>fg',
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
    -- Terminal comme LazyVim
    {
      '<c-_>', -- La vraie séquence que reçoit Neovim pour Ctrl+/
      function()
        require('snacks').terminal(nil, { cwd = vim.uv.cwd() })
      end,
      desc = 'Terminal (Root Dir)',
      mode = 'n',
    },
    {
      '<c-_>',
      '<cmd>close<cr>',
      desc = 'Hide Terminal',
      mode = 't',
    },

    -- Optionnel : ajouter aussi <c-/> au cas où
    {
      '<c-/>',
      function()
        require('snacks').terminal(nil, { cwd = vim.uv.cwd() })
      end,
      desc = 'Terminal (Root Dir)',
      mode = 'n',
    },
    {
      '<c-/>',
      '<cmd>close<cr>',
      desc = 'Hide Terminal',
      mode = 't',
    },
  },
}
