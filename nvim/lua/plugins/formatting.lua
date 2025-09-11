return {
  -- Formatage avec conform.nvim
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      -- Définir les formatters par type de fichier
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' }, -- Utiliser isort puis black
        javascript = { 'eslint_d', 'prettier' },
        typescript = { 'eslint_d', 'prettier' },
        javascriptreact = { 'eslint_d', 'prettier' },
        typescriptreact = { 'eslint_d', 'prettier' },
        vue = { 'eslint_d', 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
      },
      -- Format automatique à la sauvegarde
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
      -- Configuration pour utiliser les outils Poetry et npm
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
        prettier = {
          command = function()
            -- Essayer d'abord le projet local, puis global
            local local_prettier = vim.fn.fnamemodify('.', ':p') .. 'node_modules/.bin/prettier'
            if vim.fn.executable(local_prettier) == 1 then
              return local_prettier
            end
            return 'prettier'
          end,
        },
        eslint_d = {
          command = function()
            -- Essayer d'abord le projet local, puis global
            local local_eslint = vim.fn.fnamemodify('.', ':p') .. 'node_modules/.bin/eslint_d'
            if vim.fn.executable(local_eslint) == 1 then
              return local_eslint
            end
            return 'eslint_d'
          end,
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  -- Linting avec nvim-lint (pour flake8 et eslint_d)
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        lua = { 'luacheck' },
        python = { 'flake8' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        vue = { 'eslint_d' },
      }

      -- Configuration flake8 pour utiliser l'environnement virtuel
      lint.linters.flake8.cmd = function()
        if vim.env.VIRTUAL_ENV then
          return vim.env.VIRTUAL_ENV .. '/bin/flake8'
        end
        return 'flake8'
      end

      -- Configuration eslint_d pour utiliser le projet local
      lint.linters.eslint_d.cmd = function()
        local local_eslint = vim.fn.fnamemodify('.', ':p') .. 'node_modules/.bin/eslint_d'
        if vim.fn.executable(local_eslint) == 1 then
          return local_eslint
        end
        return 'eslint_d'
      end

      -- Auto-lint
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Linter Python seulement si un venv est activé
          local ft = vim.bo.filetype
          if ft == 'python' and not vim.env.VIRTUAL_ENV then
            return
          end
          lint.try_lint()
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
  -- Mason pour installer seulement les outils qui ne sont pas dans Poetry/npm
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'stylua', -- Lua formatter (pas dans Poetry/npm)
        'luacheck', -- Lua linter (pas dans Poetry/npm)
        'eslint_d', -- ESLint daemon pour JS/TS/Vue
        'prettier', -- Prettier pour le formatage
      })
    end,
  },
}
