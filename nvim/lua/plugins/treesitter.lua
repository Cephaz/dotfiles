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
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = false,
            node_decremental = '<bs>',
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
