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
          Snacks.explorer()
        end,
        desc = 'Explorateur de fichiers',
      },
      {
        '<leader>d',
        function()
          Snacks.dashboard.open()
        end,
        desc = 'Dashboard',
      },

      {
        '<leader>bd',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Fermer buffer',
      },
      {
        '<leader>bo',
        function()
          Snacks.bufdelete.other()
        end,
        desc = 'Fermer les autres buffers',
      },

      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>go',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Ouvrir sur GitHub',
      },

      {
        '<c-/>',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle Terminal',
        mode = { 'n', 't' },
      },

      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Chercher Fichiers',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Chercher Texte (Grep)',
      },
      {
        '<leader>bb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Liste des Buffers',
      },
    },
  },
}
