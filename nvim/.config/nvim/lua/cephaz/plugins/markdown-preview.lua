return {
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
