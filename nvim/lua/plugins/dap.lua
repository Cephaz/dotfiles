return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- =====================================================================
      -- FONCTION UTILITAIRE : LIRE LE .ENV (MIMIQUE LE MAKEFILE)
      -- =====================================================================
      -- Cette fonction fait exactement ce que ton "grep -v '^#' .env" fait.
      local function load_env_vars()
        local variables = {}
        local env_file = vim.fn.getcwd() .. '/.env'

        local f = io.open(env_file, 'r')
        if not f then
          return variables
        end

        for line in f:lines() do
          -- Ignore les commentaires et les lignes vides
          if not line:match('^#') and line:match('=') then
            -- Nettoie les 'export ' si présents (le debugger n'aime pas ça)
            local clean_line = line:gsub('^export%s+', '')
            local key, value = clean_line:match('([^=]+)=(.*)')

            if key and value then
              -- Enlève les guillemets potentiels autour de la valeur
              value = value:gsub('^[\'"]', ''):gsub('[\'"]$', '')
              variables[key] = value
            end
          end
        end
        f:close()
        return variables
      end

      -- =====================================================================
      -- 1. CONFIGURATION DE L'ADAPTATEUR
      -- =====================================================================
      local cwd = vim.fn.getcwd()
      local python_path = cwd .. '/.venv/bin/python'

      local python_adapter_config = {
        type = 'executable',
        command = python_path,
        args = { '-m', 'debugpy.adapter' },
      }

      dap.adapters.python = python_adapter_config
      dap.adapters.debugpy = python_adapter_config

      -- =====================================================================
      -- 2. CHARGEMENT DE LAUNCH.JSON & INJECTION ENV
      -- =====================================================================

      -- 1. On charge le JSON
      require('dap.ext.vscode').load_launchjs(nil, { debugpy = { 'python' } })

      -- 2. ON PATCHE LA CONFIGURATION AVEC NOS VARIABLES .ENV
      -- C'est ici que la magie opère : on force les variables dans la config chargée
      local raw_env = load_env_vars()

      if dap.configurations.python then
        for _, config in ipairs(dap.configurations.python) do
          -- On fusionne les variables existantes (du json) avec celles du .env
          config.env = vim.tbl_extend('force', config.env or {}, raw_env)
        end
      end

      -- =====================================================================
      -- 3. AUTOMATISATION (BROWSER)
      -- =====================================================================
      dap.listeners.after.event_initialized['open_browser'] = function()
        local url = 'http://0.0.0.0:8080/docs'
        local open_cmd
        if vim.fn.has('mac') == 1 then
          open_cmd = 'open ' .. url
        elseif vim.fn.has('unix') == 1 then
          open_cmd = 'xdg-open ' .. url
        else
          open_cmd = 'start ' .. url
        end
        -- Petit délai pour être sûr que l'API est UP avant d'ouvrir
        vim.defer_fn(function()
          os.execute(open_cmd)
        end, 1000)

        dapui.open()
      end

      dap.listeners.before.event_terminated['close_ui'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['close_ui'] = function()
        dapui.close()
      end

      -- =====================================================================
      -- 4. UI & SETUP
      -- =====================================================================
      dapui.setup({})
      require('nvim-dap-virtual-text').setup({ commented = true })

      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
      vim.fn.sign_define(
        'DapBreakpointRejected',
        { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapStopped',
        { text = '', texthl = 'DiagnosticSignWarn', linehl = 'Visual', numhl = 'DiagnosticSignWarn' }
      )

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, opts)
      vim.keymap.set('n', '<leader>dc', dap.continue, opts)
      vim.keymap.set('n', '<leader>di', dap.step_into, opts)
      vim.keymap.set('n', '<leader>do', dap.step_over, opts)
      vim.keymap.set('n', '<leader>dO', dap.step_out, opts)
      vim.keymap.set('n', '<leader>dq', dap.terminate, opts)
      vim.keymap.set('n', '<leader>du', dapui.toggle, opts)

      -- Raccourci pour recharger la config et les variables d'env sans redémarrer nvim
      vim.keymap.set('n', '<leader>dr', function()
        require('dap.ext.vscode').load_launchjs(nil, { debugpy = { 'python' } })
        local new_env = load_env_vars()
        if dap.configurations.python then
          for _, config in ipairs(dap.configurations.python) do
            config.env = vim.tbl_extend('force', config.env or {}, new_env)
          end
        end
        print('Configuration et .env rechargés !')
      end, opts)
    end,
  },
}
