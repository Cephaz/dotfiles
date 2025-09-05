return {
  -- Formatage avec conform.nvim
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_fallback = true })
        end,
        mode = { 'n', 'v' },
        desc = 'Format buffer',
      },
    },
    opts = {
      -- Définir les formatters par type de fichier
      formatters_by_ft = {
        lua = { 'stylua' },
        -- On ajoutera d'autres langages plus tard
        -- python = { "ruff_format" },
        -- javascript = { "prettier" },
        -- typescript = { "prettier" },
        -- vue = { "prettier" },
      },

      -- Format automatique à la sauvegarde
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
    init = function()
      -- Format sur save pour certains types seulement
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Mason pour installer automatiquement stylua
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'stylua', -- Lua formatter
      })
    end,
  },
}
