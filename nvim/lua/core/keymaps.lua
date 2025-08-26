-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- window splits sous <leader>w
vim.keymap.set("n", "<leader>ws", "<C-w>s", opts) -- split horizontal
vim.keymap.set("n", "<leader>wv", "<C-w>v", opts) -- split vertical
vim.keymap.set("n", "<leader>wh", "<C-w>h", opts) -- aller à gauche
vim.keymap.set("n", "<leader>wj", "<C-w>j", opts) -- aller en bas
vim.keymap.set("n", "<leader>wk", "<C-w>k", opts) -- aller en haut
vim.keymap.set("n", "<leader>wl", "<C-w>l", opts) -- aller à droite
vim.keymap.set("n", "<leader>wq", "<C-w>q", opts) -- fermer la fenetre
