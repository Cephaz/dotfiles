local map = vim.keymap.set

-- Meilleure navigation fenêtres
map('n', '<C-h>', '<C-w>h', { desc = 'Aller à la fenêtre de gauche' })
map('n', '<C-j>', '<C-w>j', { desc = 'Aller à la fenêtre du bas' })
map('n', '<C-k>', '<C-w>k', { desc = 'Aller à la fenêtre du haut' })
map('n', '<C-l>', '<C-w>l', { desc = 'Aller à la fenêtre de droite' })

-- Gestion des buffers
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Fermer le buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Buffer suivant' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Buffer précédent' })

-- Déplacer du texte
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Déplacer sélection vers le bas' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Déplacer sélection vers le haut' })

-- Indentation
map('v', '<', '<gv', { desc = 'Indenter à gauche' })
map('v', '>', '>gv', { desc = 'Indenter à droite' })

-- Clear search
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Effacer surlignage recherche' })

-- Sauvegarde
map('n', '<leader>w', '<cmd>w<cr>', { desc = 'Sauvegarder' })

-- Quitter
map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quitter' })

-- Navigation rapide
map('n', 'J', 'mzJ`z', { desc = 'Joindre lignes' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Demi-page bas' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Demi-page haut' })

-- Search center
map('n', 'n', 'nzzzv', { desc = 'Recherche suivante' })
map('n', 'N', 'Nzzzv', { desc = 'Recherche précédente' })

-- Diagnostics (warnings, errors, etc.)
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Open diagnostic list' })
