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
          'lua_ls',
          'pyright',
          'vtsls',
          'vue_ls',
          'jsonls',
        },
        automatic_installation = true,
      })
    end,
  },
  -- SchemaStore : schémas JSON pour validation
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- dernière version du main
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
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config('pyright', {
        settings = {
          pyright = {
            disableOrganizeImports = false,
          },
          python = {
            analysis = {
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

      local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

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
        on_attach = function(client, bufnr)
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

      vim.lsp.config('vtsls', vtsls_config)

      -- Configuration pour JSON avec SchemaStore
      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.api.nvim_create_autocmd('BufReadPost', {
        pattern = '*.json',
        callback = function()
          local lspconfig = require('lspconfig')
          lspconfig.jsonls.setup({
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              },
            },
          })
          vim.cmd('LspRestart jsonls')
        end,
      })

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
