return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    config = function()
      -- import nvim-treesitter plugin
      local treesitter = require('nvim-treesitter.configs')

      -- configure treesitter
      treesitter.setup({
        -- enable syntax highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        -- enable indentation
        indent = { enable = true },

        -- ensure these languages parsers are installed
        ensure_installed = {
          'json',
          'javascript',
          'typescript',
          'tsx',
          'vue',
          'yaml',
          'html',
          'css',
          'python',
          'lua',
          'luadoc',
          'dockerfile',
          'gitignore',
          'query',
          'markdown',
          'terraform',
          'bash',
          'toml',
        },

        -- enable incremental selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-n>',
            node_incremental = '<C-n>',
            node_decremental = '<C-p>',
            scope_incremental = false,
          },
        },

        -- enable auto tag (pour HTML/JSX/Vue)
        autotag = {
          enable = true,
        },
      })
    end,
  },
}
