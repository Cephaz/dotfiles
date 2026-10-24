-- Buffer completion without a plugin; LSP buffers use the asynchronous LSP menu.
vim.o.autocomplete = true
vim.opt.complete = { '.', 'w', 'b' }
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
vim.opt.wildmode = { 'longest:full', 'full' }
vim.opt.wildoptions:append 'pum'

local keymap = vim.keymap.set
keymap('i', '<C-Space>', function()
  vim.lsp.completion.get()
end, { desc = 'LSP completion' })

keymap('i', '<C-j>', '<C-n>', { desc = 'Next completion' })
keymap('i', '<C-k>', '<C-p>', { desc = 'Previous completion' })
keymap('i', '<CR>', function()
  local selected = vim.fn.complete_info({ 'selected' }).selected
  return vim.fn.pumvisible() == 1 and selected >= 0 and '<C-y>' or '<CR>'
end, { expr = true, desc = 'Accept selected completion or newline' })

for key, direction in pairs { ['<Tab>'] = 1, ['<S-Tab>'] = -1 } do
  keymap({ 'i', 's' }, key, function()
    if vim.snippet.active { direction = direction } then
      vim.snippet.jump(direction)
    else
      local fallback = vim.api.nvim_replace_termcodes(key, true, false, true)
      vim.api.nvim_feedkeys(fallback, 'n', false)
    end
  end, { desc = 'Jump snippet placeholder' })
end
