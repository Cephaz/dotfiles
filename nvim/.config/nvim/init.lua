if vim.fn.has 'nvim-0.12' == 0 then
  error 'Cette configuration nécessite Neovim 0.12 ou supérieur.'
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'cephaz'
