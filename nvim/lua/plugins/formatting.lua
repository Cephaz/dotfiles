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
        python = { 'isort', 'black' }, -- Utiliser isort puis black
      },

      -- Format automatique à la sauvegarde
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },

      -- Configuration pour utiliser les outils Poetry
      formatters = {
        black = {
          command = function()
            -- Utiliser black depuis l'environnement virtuel Poetry
            if vim.env.VIRTUAL_ENV then
              return vim.env.VIRTUAL_ENV .. '/bin/black'
            end
            return 'black'
          end,
        },
        isort = {
          command = function()
            -- Utiliser isort depuis l'environnement virtuel Poetry
            if vim.env.VIRTUAL_ENV then
              return vim.env.VIRTUAL_ENV .. '/bin/isort'
            end
            return 'isort'
          end,
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Linting avec nvim-lint (pour flake8)
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')

      lint.linters_by_ft = {
        lua = { 'luacheck' },
        python = { 'flake8' },
      }

      -- Configuration flake8 pour utiliser l'environnement virtuel
      lint.linters.flake8.cmd = function()
        if vim.env.VIRTUAL_ENV then
          return vim.env.VIRTUAL_ENV .. '/bin/flake8'
        end
        return 'flake8'
      end

      -- Auto-lint
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Seulement linter si un venv est activé
          if vim.env.VIRTUAL_ENV then
            lint.try_lint()
          end
        end,
      })

      -- Relancer le linting quand l'environnement change
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VenvSelectActivated',
        callback = function()
          vim.defer_fn(function()
            lint.try_lint()
          end, 1000)
        end,
      })
    end,
  },

  -- Mason pour installer seulement les outils qui ne sont pas dans Poetry
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'stylua', -- Lua formatter (pas dans Poetry)
        'luacheck', -- Lua linter (pas dans Poetry)
        -- black, isort, flake8 sont gérés par Poetry
      })
    end,
  },
}
