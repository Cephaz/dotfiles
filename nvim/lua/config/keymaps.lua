local map = vim.keymap.set

-- Meilleure navigation fenêtres
map('n', '<leader>ws', '<C-w>s', { desc = 'split horizontal' }) -- split horizontal
map('n', '<leader>wv', '<C-w>v', { desc = 'split vertical' }) -- split vertical
map('n', '<leader>wq', '<C-w>q', { desc = 'close window' }) -- fermer la fenetre
map('n', '<C-h>', '<C-w>h', { desc = 'Aller à la fenêtre de gauche' })
map('n', '<C-j>', '<C-w>j', { desc = 'Aller à la fenêtre du bas' })
map('n', '<C-k>', '<C-w>k', { desc = 'Aller à la fenêtre du haut' })
map('n', '<C-l>', '<C-w>l', { desc = 'Aller à la fenêtre de droite' })

-- Gestion des buffers
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Fermer le buffer' })
map('n', '<leader>bb', '<C-^>', { desc = 'Alterner avec le buffer précédent' })
-- map('n', ']b', '<cmd>bnext<cr>', { desc = 'Buffer suivant' })
-- map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Buffer précédent' })

-- Déplacer du texte
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Déplacer sélection vers le bas' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Déplacer sélection vers le haut' })

-- Indentation
map('v', '<', '<gv', { desc = 'Indenter à gauche' })
map('v', '>', '>gv', { desc = 'Indenter à droite' })

-- Clear search
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Effacer surlignage recherche' })

-- Sauvegarde
map('n', '<c-s>', '<cmd>w<cr>', { desc = 'Sauvegarder' })
map('i', '<c-s>', '<esc><cmd>w<cr>a', { desc = 'Sauvegarder en mode insert' })
map('n', '<leader>sf', '<cmd>noautocmd w<cr>', { desc = 'Sauvegarder sans formater' })
-- Quitter
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quitter Neovim entier' })
-- map('n', '<leader>qs', '<cmd>q<cr>', { desc = 'Quitter' })

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

-- Raccourci pour create PR
-- vim.keymap.set('n', '<leader>gp', function()
--   vim.cmd('!gh pr create --fill --web')
-- end, { desc = 'GitHub: Create PR', silent = true })
--
-- vim.keymap.set('n', '<leader>gp', function()
--   vim.cmd('!gh pr create --web --body "$(cat .developer/pull_request_template.md)"')
-- end, { desc = 'GitHub: Create PR (with template)', silent = true })
--
-- vim.keymap.set('n', '<leader>gp', function()
--   local template = vim.fn.system('cat .developer/pull_request_template.md')
--   vim.fn.system('gh pr create --web --body "' .. template .. '"')
-- end, { desc = 'GitHub: Create PR (with template)' })

map('n', '<leader>zw', '<cmd>set wrap!<cr>', { desc = 'Toggle word wrap' })

-- Raccourci pour changer l'indentation à 2 espaces
map('n', '<leader>i2', function()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.expandtab = true
  print('Indentation: 2 espaces')
end, { desc = 'Set indentation to 2 spaces' })

-- Raccourci pour changer l'indentation à 4 espaces
map('n', '<leader>i4', function()
  vim.bo.shiftwidth = 4
  vim.bo.tabstop = 4
  vim.bo.expandtab = true
  print('Indentation: 4 espaces')
end, { desc = 'Set indentation to 4 spaces' })

-- ========================================
-- FOLDING CONFIGURATION
-- ========================================
-- Active le folding avec Treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99 -- Tout ouvert par défaut
vim.opt.foldenable = true -- Active le folding

-- Personnalisation de l'affichage des folds (format standard)
vim.opt.fillchars = { fold = ' ' }
vim.opt.foldtext =
  [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

-- Keymaps pour le folding
map('n', 'zc', 'zc', { desc = 'Fermer un fold' })
map('n', 'zo', 'zo', { desc = 'Ouvrir un fold' })
map('n', 'za', 'za', { desc = 'Toggle fold' })
