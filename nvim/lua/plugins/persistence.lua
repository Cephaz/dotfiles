-- lua/plugins/persistence.lua
return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- charge avant ouverture du buffer
  opts = {
    dir = vim.fn.stdpath('state') .. '/sessions/',
    options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
  },
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Restaurer la session courante',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load({ last = true })
      end,
      desc = 'Restaurer la dernière session',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = 'Ne pas sauvegarder la session courante',
    },
  },
}
