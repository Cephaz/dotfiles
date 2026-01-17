return {
  'hrsh7th/cmp-nvim-lsp',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/lazydev.nvim', opts = {} },
    'neovim/nvim-lspconfig',
  },
  config = function()
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    -- 2. Surcharge spécifique pour Pyright
    -- vim.lsp.config('pyright', {
    --   capabilities = capabilities,
    --   settings = {
    --     pyright = {
    --       disableOrganizeImports = false,
    --     },
    --     python = {
    --       analysis = {
    --         typeCheckingMode = 'basic',
    --         autoSearchPaths = true,
    --         useLibraryCodeForTypes = true,
    --         autoImportCompletions = true,
    --       },
    --     },
    --   },
    -- })
  end,
}
