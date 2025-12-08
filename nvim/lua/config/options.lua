local opt = vim.opt

-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Interface
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv('HOME') .. '/.vim/undodir'

-- Colors
opt.termguicolors = true

-- Completion
opt.completeopt = 'menu,menuone,noselect'

-- Mouse
opt.mouse = 'a'

-- Clipboard
opt.clipboard = 'unnamedplus'

vim.o.autoread = true
vim.opt.confirm = true

-- -- Hack nécessaire : Neovim ne déclenche pas toujours autoread tout seul
-- -- Ajoute ceci pour forcer la vérification quand tu reviens sur la fenêtre
-- vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
--   command = "checktime",
-- })
