return {
  'f-person/git-blame.nvim',
  event = 'BufReadPost',
  config = function()
    vim.g.gitblame_enabled = 1
  end,
}
