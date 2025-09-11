return {
  {
    'linux-cultist/venv-selector.nvim',
    branch = 'regexp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('venv-selector').setup({
        -- Configuration du cache pour mémoriser les venv par projet
        -- cache_dir = vim.fn.stdpath('cache') .. '/venv-selector',
        -- cache_enabled = true,

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
