return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      explorer = {
        enabled = true,
        replace_netrw = true,
        git_status_symbols = {
          added = '+',
          modified = '~',
          deleted = 'x',
        },
      },
      bufdelete = { enabled = true },
      winbar = { enabled = true },
      indent = { enabled = true },
      dashboard = { enabled = true },
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

      picker = { enabled = true },
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
    },
  },
}
