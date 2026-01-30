local keymap = vim.keymap.set

-- Neovim
keymap('n', '<leader>qq', '<cmd>qa!<cr>', { desc = 'Quit All (Force)' })

-- File
keymap('n', '<C-s>', '<cmd> w <CR>', { desc = 'Save file' })
keymap('n', '<C-q>', '<cmd> q <CR>', { desc = 'Quit file' })
keymap(
  'n',
  '<leader>sf',
  '<cmd>noautocmd w <CR>',
  { desc = 'Save file (no format)' }
)

-- Window
keymap('n', '<leader>ws', '<C-w>s', { desc = 'Split horizontal' })
keymap('n', '<leader>wv', '<C-w>v', { desc = 'Split vertical' })
keymap('n', '<leader>wq', '<C-w>q', { desc = 'Close window' })

-- Window navigation
keymap('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Indent
keymap('n', '<leader>i2', function()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.expandtab = true
  print 'Indentation: 2 espaces'
end, { desc = 'Set indentation to 2 spaces' })

keymap('n', '<leader>i4', function()
  vim.bo.shiftwidth = 4
  vim.bo.tabstop = 4
  vim.bo.expandtab = true
  print 'Indentation: 4 espaces'
end, { desc = 'Set indentation to 4 spaces' })
