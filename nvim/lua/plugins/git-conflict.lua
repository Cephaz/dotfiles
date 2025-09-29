return {
  'akinsho/git-conflict.nvim',
  version = '*',
  config = function()
    require('git-conflict').setup({
      default_mappings = false,
      disable_diagnostics = true,
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
      },
    })

    vim.keymap.set('n', '[x', '<Plug>(git-conflict-ours)', { desc = 'Git Conflict - Choose current' })
    vim.keymap.set('n', ']x', '<Plug>(git-conflict-theirs)', { desc = 'Git Conflict - Choose incoming' })
    vim.keymap.set('n', 'cx', '<Plug>(git-conflict-both)', { desc = 'Git Conflict - Choose both' })
  end,
}
