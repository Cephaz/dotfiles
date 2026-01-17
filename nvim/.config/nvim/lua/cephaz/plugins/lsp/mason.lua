return {
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
        'lua_ls',
        'pyright',
        'vtsls',
        'vue_ls',
        'jsonls',
      },
    },
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {
          ui = {
            icons = {
              package_installed = '✓',
              package_pending = '➜',
              package_uninstalled = '✗',
            },
          },
        },
      },
      'neovim/nvim-lspconfig',
    },
  },
  {
    'whoissethdaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'stylua', -- Lua formatter
        'luacheck', -- Lua linter
        'eslint_d', -- ESLint daemon pour JS/TS/Vue
        'prettier', -- Prettier pour le formatage
        'jq',
        'tflint', -- Terraform linter
      },
    },
    dependencies = {
      'williamboman/mason.nvim',
    },
  },
}
