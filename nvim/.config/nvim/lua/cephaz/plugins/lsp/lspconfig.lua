return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/lazydev.nvim', opts = {} },
  },
  config = function()
    -- Configuration pour TypeScript/JavaScript
    -- Resolve from the active Node installation (including nvm), not Mason.
    local vue_language_server_path = vim.env.NVIM_VUE_LANGUAGE_SERVER_PATH
    if not vue_language_server_path then
      local executable = vim.fn.exepath 'vue-language-server'
      local resolved = executable ~= '' and vim.uv.fs_realpath(executable)
      if resolved then
        vue_language_server_path = vim.fs.dirname(vim.fs.dirname(resolved))
      end
    end

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
            globalPlugins = vue_language_server_path and {
              vue_plugin,
            } or {},
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
    -- Vue requires the JavaScript TypeScript API, absent from TypeScript 7.
    -- Use the same compatible SDK bundled with vtsls for both servers.
    local vtsls_executable = vim.fn.exepath 'vtsls'
    local vtsls_resolved = vtsls_executable ~= ''
      and vim.uv.fs_realpath(vtsls_executable)
    if vtsls_resolved then
      local tsdk = vim.fs.joinpath(
        vim.fs.dirname(vim.fs.dirname(vtsls_resolved)),
        'node_modules',
        'typescript',
        'lib'
      )
      if vim.fn.filereadable(vim.fs.joinpath(tsdk, 'typescript.js')) == 1 then
        vue_ls_config.cmd = { 'vue-language-server', '--stdio', '--tsdk=' .. tsdk }
      end
    end

    vim.lsp.config('vtsls', vtsls_config)
    vim.lsp.config('vue_ls', vue_ls_config)
    vim.lsp.config('jsonls', {
      -- Use the Node executable installed globally, like the other servers.
      cmd = { 'vscode-json-language-server', '--stdio' },
      settings = {
        json = {
          validate = { enable = true },
        },
      },
    })
    local group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true })
    vim.api.nvim_create_autocmd('LspAttach', {
      group = group,
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method 'textDocument/completion' then
          vim.bo[ev.buf].autocomplete = false
          local provider = client.server_capabilities.completionProvider
          local triggers = provider.triggerCharacters or {}
          for char in
            ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'):gmatch '.'
          do
            if not vim.tbl_contains(triggers, char) then
              triggers[#triggers + 1] = char
            end
          end
          provider.triggerCharacters = triggers
          vim.lsp.completion.enable(
            true,
            client.id,
            ev.buf,
            { autotrigger = true }
          )
        end

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
        keymap('n', '<leader>rs', function()
          for _, attached in ipairs(vim.lsp.get_clients { bufnr = ev.buf }) do
            vim.lsp.enable(attached.name, false)
            vim.lsp.enable(attached.name)
          end
        end, opts)
      end,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = group,
      callback = function(ev)
        for _, client in ipairs(vim.lsp.get_clients { bufnr = ev.buf }) do
          if
            client.id ~= ev.data.client_id
            and client:supports_method 'textDocument/completion'
          then
            return
          end
        end
        vim.bo[ev.buf].autocomplete = true
      end,
    })

    for _, name in ipairs {
      'lua_ls',
      'jsonls',
      'taplo',
      'rust_analyzer',
      'pyright',
      'vtsls',
      'vue_ls',
    } do
      local config = vim.lsp.config[name]
      if
        config
        and type(config.cmd) == 'table'
        and vim.fn.executable(config.cmd[1]) == 1
      then
        vim.lsp.enable(name)
      end
    end
  end,
}
