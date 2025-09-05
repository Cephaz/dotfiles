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

      -- Configuration pour le serveur Lua
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            -- Version de Lua
            runtime = {
              version = 'LuaJIT',
            },
            -- Reconnaître les variables globales Neovim
            diagnostics = {
              globals = {
                'vim',
                'describe',
                'it',
                'before_each',
                'after_each',
              },
              disable = { 'missing-fields' },
            },
            -- Workspace pour Neovim
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
              checkThirdParty = false,
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
            -- Pas de télémétrie
            telemetry = {
              enable = false,
            },
            completion = {
              callSnippet = 'Replace',
            },
            hint = {
              enable = true,
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
          vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        end,
      })
    end,
  },
}
