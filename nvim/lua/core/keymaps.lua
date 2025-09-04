-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

-- save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- window splits sous <leader>w
vim.keymap.set("n", "<leader>ws", "<C-w>s", opts) -- split horizontal
vim.keymap.set("n", "<leader>wv", "<C-w>v", opts) -- split vertical
vim.keymap.set("n", "<leader>wq", "<C-w>q", opts) -- fermer la fenetre

-- Navigation entre fenêtres avec Ctrl + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Aller à gauche" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Aller en bas" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Aller en haut" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Aller à droite" })

-- Raccourci pour create PR
vim.keymap.set("n", "<leader>gp", function()
	vim.cmd("!gh pr create --fill --web")
end, { desc = "GitHub: Create PR", silent = true })
