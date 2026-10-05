return {
  'mfussenegger/nvim-dap',
  ft = 'python',
  dependencies = {
    'mfussenegger/nvim-dap-python',
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
    'williamboman/mason.nvim',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Continue',
    },
    {
      '<F9>',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Breakpoint',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F12>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>Dc',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Continue',
    },
    {
      '<leader>Db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Breakpoint',
    },
    {
      '<leader>Do',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>Di',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>DO',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>Du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
    {
      '<leader>Dr',
      function()
        require('dap').repl.open()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'dap-repl' then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end,
      desc = 'Debug: Console',
    },
    {
      '<leader>De',
      function()
        require('dapui').eval()
      end,
      mode = { 'n', 'v' },
      desc = 'Debug: Evaluate',
    },
    {
      '<leader>Dq',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Stop',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dapui.setup {}
    require('dap-python').setup(
      vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
    )
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        console = 'integratedTerminal',
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    -- Keep the console visible after exit so output can still be inspected.
  end,
}
