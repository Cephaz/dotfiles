return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/lazydev.nvim', opts = {} },
  },
  config = function()
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.lsp.enable 'lua_ls'

    -- Configuration pour TypeScript/JavaScript
    local vue_language_server_path = vim.fn.stdpath 'data'
      .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

    local tsserver_filetypes = {
      'typescript',
      'javascript',
      'javascriptreact',
      'typescriptreact',
      'vue',
    }
    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
    }
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

    local vue_ls_config = {}

    vim.lsp.config('vtsls', vtsls_config)
    vim.lsp.config('vue_ls', vue_ls_config)
    vim.lsp.enable { 'vtsls', 'vue_ls' }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local keymap = vim.keymap.set

        opts.desc = 'See available code actions'
        keymap({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

        opts.desc = 'Smart rename'
        keymap('n', '<leader>rn', vim.lsp.buf.rename, opts)

        opts.desc = 'Show line diagnostics'
        keymap('n', '<leader>d', vim.diagnostic.open_float, opts)

        opts.desc = 'Go to previous diagnostic'
        keymap('n', '[d', function()
          vim.diagnostic.jump { count = -1, float = true }
        end, opts)

        opts.desc = 'Go to next diagnostic'
        keymap('n', ']d', function()
          vim.diagnostic.jump { count = 1, float = true }
        end, opts)

        opts.desc = 'Show documentation'
        keymap('n', 'K', vim.lsp.buf.hover, opts)

        opts.desc = 'Restart LSP'
        keymap('n', '<leader>rs', ':LspRestart<CR>', opts)
      end,
    })
  end,
}
