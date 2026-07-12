return {
  'nvim-lua/plenary.nvim',
  'christoomey/vim-tmux-navigator',
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
  },
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup {}

      vim.keymap.set('n', '<leader>sr', function()
        require('grug-far').open()
      end, { desc = 'Search and Replace (grug-far)' })
    end,
  },
  {
    'ellisonleao/glow.nvim',
    ft = { 'markdown' },
    cmd = { 'Glow' },
    opts = {
      style = 'dark',
      width = 120,
      border = 'rounded',
      pager = false,
    },
    keys = {
      {
        '<leader>mp',
        '<cmd>Glow<cr>',
        desc = 'Markdown Preview',
      },
    },
  },
}
