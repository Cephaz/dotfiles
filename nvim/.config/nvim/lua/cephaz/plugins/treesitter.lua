return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require 'nvim-treesitter'
    treesitter.setup()
    treesitter.install {
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
      'markdown_inline',
      'terraform',
      'bash',
      'toml',
      'vim',
      'vimdoc',
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
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
        'markdown_inline',
        'terraform',
        'bash',
        'toml',
        'vim',
        'vimdoc',
      },
      callback = function()
        -- syntax highlighting, provided by Neovim
        vim.treesitter.start()
        -- folds, provided by Neovim (I don't like folds)
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'
        -- indentation, provided by nvim-treesitter
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
