return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local treesitter = require 'nvim-treesitter'
      treesitter.setup {
        install_dir = vim.fn.stdpath('data') .. '/site',
      }

      local parsers = {
        'json',
        'javascript',
        'typescript',
        'tsx',
        'vue',
        'yaml',
        'html',
        'css',
        'scss',
        'markdown',
        'markdown_inline',
        'bash',
        'lua',
        'vim',
        'vimdoc',
        'dockerfile',
        'gitignore',
        'python',
        'rust',
      }

      -- JSON needs both its parser and highlighting queries in the new layout.
      treesitter.install { 'json' }

      vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
        group = vim.api.nvim_create_augroup(
          'NativeTreesitter',
          { clear = true }
        ),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if not lang or not vim.tbl_contains(parsers, lang) then
            return
          end

          -- Keep regex highlighting/ftplugin indentation if a parser is absent.
          if pcall(vim.treesitter.start, ev.buf, lang) then
            vim.bo[ev.buf].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
