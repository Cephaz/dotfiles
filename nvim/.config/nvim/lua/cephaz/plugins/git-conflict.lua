return {
  'akinsho/git-conflict.nvim',
  version = '*',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    default_mappings = {
      ours = 'co',
      theirs = 'ct',
      both = 'cb',
      none = 'c0',
      next = ']x',
      prev = '[x',
    },
  },
}
