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
          'vtsls',
          'vue_ls', -- Serveur LSP pour Vue.js
          -- 'ts_ls', -- TypeScript/JavaScript (requis pour vue_ls)
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
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }, -- déclare "vim" comme global
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
          },
        },
      })

      -- Configuration pour Python
      lspconfig.pyright.setup({
        settings = {
          pyright = {
            disableOrganizeImports = false,
          },
          python = {
            analysis = {
              ignore = { '*' },
              typeCheckingMode = 'basic',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
          },
        },
      })

      -- Configuration pour TypeScript/JavaScript
      local vue_language_server_path = vim.fn.stdpath('data')
        .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

      local tsserver_filetypes =
        { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

      -- Plugin Vue selon la doc officielle
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      -- Configuration vtsls selon la doc officielle Vue
      local vtsls_config = {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_plugin,
              },
            },
          },
        },
        filetypes = tsserver_filetypes,
        -- 🎯 SOLUTION OFFICIELLE pour les semantic tokens (doc Vue v3.0.5+)
        on_attach = function(client, bufnr)
          -- Configuration officielle : désactiver semantic tokens pour Vue
          if vim.bo[bufnr].filetype == 'vue' then
            if client.server_capabilities.semanticTokensProvider then
              client.server_capabilities.semanticTokensProvider.full = false
            end
          else
            if client.server_capabilities.semanticTokensProvider then
              client.server_capabilities.semanticTokensProvider.full = true
            end
          end
        end,
      }

      -- Configuration Vue Language Server (doc officielle récente)
      -- local vue_ls_config = {}

      -- 🎯 Setup selon la documentation officielle nvim-lspconfig récent
      lspconfig.vtsls.setup(vtsls_config)
      -- lspconfig.vue_ls.setup(vue_ls_config)

      -- Keymaps LSP (quand un serveur LSP est actif)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          -- Navigation LSP
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
