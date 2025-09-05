return {
  -- Mason : gestionnaire d'outils LSP/linters/formatters
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = {
      { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' },
    },
    build = ':MasonUpdate',
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
        },
      })
    end,
  },

  -- Mason LSP Config : gère l'installation des serveurs LSP
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls', -- Serveur LSP pour Lua
          'pyright', -- Serveur LSP pour Python (équivalent de Pylance)
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Config : configuration des serveurs
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')

      -- Configuration pour Lua (simplifiée car on a .luarc.json)
      lspconfig.lua_ls.setup({})

      -- Configuration pour Python
      lspconfig.pyright.setup({
        settings = {
          pyright = {
            -- Laisser ruff gérer les imports et le formatage
            disableOrganizeImports = false,
          },
          python = {
            analysis = {
              -- Laisser ruff gérer le linting
              ignore = { '*' },
              typeCheckingMode = 'basic',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
          },
        },
      })

      -- Keymaps LSP (quand un serveur LSP est actif)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          -- Navigation LSP
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

          -- Actions LSP
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

          -- Diagnostics
          vim.keymap.set('n', '<leader>cd', function()
            vim.diagnostic.open_float()
          end, opts)
          vim.keymap.set('n', ']d', function()
            vim.diagnostic.goto_next()
          end, opts)
          vim.keymap.set('n', '[d', function()
            vim.diagnostic.goto_prev()
          end, opts)
        end,
      })
    end,
  },
}
