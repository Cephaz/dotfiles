return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      bufdelete = { enabled = true },
      winbar = { enabled = true },
      indent = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          {
            section = 'projects',
            icon = ' ',
            title = 'Projets Récents',
            padding = 1,
            limit = 5,
          },

          {
            section = 'recent_files',
            icon = ' ',
            title = 'Fichiers Récents',
            padding = 1,
            indent = 2,
            limit = 5,
          },
        },
      },
      notifier = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },

      input = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },

      words = { enabled = true },
      scope = { enabled = true },

      lazygit = { enabled = true },
      terminal = { enabled = true },
      gitbrowse = { enabled = true },

      picker = {
        enabled = true,
        icons = {
          git = {
            added = ' ',
            modified = ' ',
            deleted = ' ',
            renamed = ' ',
            untracked = ' ',
            ignored = ' ',
            staged = ' ',
          },
        },
      },
    },

    keys = {
      {
        '<leader>e',
        function()
          require('snacks').explorer()
        end,
        desc = 'File Explorer',
      },

      {
        '<leader>bd',
        function()
          require('snacks').bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>bo',
        function()
          require('snacks').bufdelete.other()
        end,
        desc = 'Delete Other Buffers',
      },

      {
        '<leader>gg',
        function()
          require('snacks').lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>go',
        function()
          require('snacks').gitbrowse()
        end,
        desc = 'Open on GitHub',
      },

      {
        '<c-/>',
        function()
          -- require('snacks').terminal()
          require('snacks').terminal.toggle(nil, {
            win = { position = 'float', border = 'rounded' },
          })
        end,
        desc = 'Toggle Terminal',
        mode = { 'n', 't' },
      },

      {
        '<leader>ff',
        function()
          require('snacks').picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>fg',
        function()
          require('snacks').picker.grep()
        end,
        desc = 'Grep Text',
      },
      {
        '<leader>bb',
        function()
          require('snacks').picker.buffers()
        end,
        desc = 'Find Buffers',
      },

      {
        'gd',
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = 'Goto Definition',
      },
      {
        'gR',
        function()
          Snacks.picker.lsp_references()
        end,
        desc = 'References',
      },
      {
        'gi',
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = 'Goto Implementation',
      },
      {
        'gt',
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = 'Goto Type Definition',
      },
      {
        '<leader>D',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = 'Buffer Diagnostics',
      },
    },
  },
}
