local keymap = vim.keymap.set

keymap('n', '<leader>qq', '<cmd>qa!<cr>', { desc = 'Quit All (Force)' })
-- save file
keymap('n', '<C-s>', '<cmd> w <CR>', opts)
-- save file without auto-formatting
keymap('n', '<leader>sf', '<cmd>noautocmd w <CR>', opts)
-- quit file
keymap('n', '<C-q>', '<cmd> q <CR>', opts)

-- Split horizontal
keymap('n', '<leader>ws', '<C-w>s', { desc = 'Split horizontal' })

-- Split vertical
keymap('n', '<leader>wv', '<C-w>v', { desc = 'Split vertical' })

-- Fermer la fenêtre actuelle
keymap('n', '<leader>wq', '<C-w>q', { desc = 'Fermer la fenêtre' })

keymap('n', '<C-h>', '<C-w>h', { desc = 'Aller à la fenêtre de gauche' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Aller à la fenêtre du bas' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Aller à la fenêtre du haut' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Aller à la fenêtre de droite' })
