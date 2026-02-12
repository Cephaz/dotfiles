return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'ConformInfo' },

  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      rust = { 'rustfmt' },
      python = { 'isort', 'black' },
      --
      javascript = { 'eslint_d', 'prettier' },
      typescript = { 'eslint_d', 'prettier' },
      -- javascriptreact = { 'eslint_d', 'prettier' },
      -- typescriptreact = { 'eslint_d', 'prettier' },
      vue = { 'eslint_d', 'prettier' },

      css = { 'prettier' },
      scss = { 'prettier' },
      html = { 'prettier' },
      -- terraform = { 'terraform_fmt' },
      -- json = { 'jq' },
      -- yaml = { 'prettier' },
      markdown = { 'prettier' },
    },

    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 3000,
    },
  },

  keys = {
    {
      '<leader>mp',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = { 'n', 'v' },
      desc = 'Format file or range',
    },
  },
}
