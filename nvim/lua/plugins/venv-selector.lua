return {
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
    },
    branch = 'regexp',
    config = function()
      require('venv-selector').setup({

        search = {
          -- Poetry virtualenvs
          {
            name = 'poetry',
            -- Expression régulière pour trouver les venv Poetry
            pattern = vim.fn.expand('~/.cache/pypoetry/virtualenvs/.*$'),
          },
          -- Venv locaux
          {
            name = 'venv-local',
            pattern = './.venv',
          },
        },

        -- Auto reload du venv depuis le cache
        auto_reload = true,
      })
    end,
  },
}
