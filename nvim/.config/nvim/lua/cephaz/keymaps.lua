-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)
-- save file without auto-formatting
vim.keymap.set('n', '<leader>sf', '<cmd>noautocmd w <CR>', opts)
-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

