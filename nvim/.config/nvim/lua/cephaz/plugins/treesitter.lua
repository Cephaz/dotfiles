return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local treesitter = require 'nvim-treesitter'
      treesitter.setup {}

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

      -- Parser compilation needs tree-sitter-cli and a C compiler.
      if
        vim.fn.executable 'tree-sitter' == 1 and vim.fn.executable 'cc' == 1
      then
        if type(treesitter.install) == 'function' then
          treesitter.install(parsers)
        elseif vim.fn.exists ':TSInstall' == 2 then
          -- Older checkouts of nvim-treesitter main expose installation only
          -- through the command, not the Lua API.
          vim.cmd('TSInstall ' .. table.concat(parsers, ' '))
        else
          vim.notify(
            'nvim-treesitter has no parser install API; run :Lazy sync and :TSUpdate',
            vim.log.levels.WARN
          )
        end
      end

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
