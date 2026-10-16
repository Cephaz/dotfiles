return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- Keep the legacy setup API; main uses a different configuration.
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local treesitter = require 'nvim-treesitter.configs'

      treesitter.setup {
        ensure_installed = {
          'json',
          'javascript',
          'typescript',
          'tsx',
          'yaml',
          'html',
          'css',
          'scss',
          'markdown',
          'markdown_inline',
          'bash',
          'lua',
          'vim',
          'dockerfile',
          'gitignore',
          'python',
          'rust',
        },

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        indent = { enable = true },
      }
    end,
  },
}
