return {
  -- Colorscheme Nightfox
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nightfox').setup({
        options = {
          transparent = false,
          terminal_colors = true,
        },
      })
      vim.cmd([[colorscheme nightfox]])
    end,
  },

  -- Colorscheme Tokyo Night
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 999,
    config = function()
      require('tokyonight').setup({
        style = 'night',
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          sidebars = 'dark',
          floats = 'dark',
        },
      })
    end,
  },

  -- Theme Picker
  {
    'zaldih/themery.nvim',
    lazy = false,
    config = function()
      require('themery').setup({
        themes = {
          { name = 'Nightfox', colorscheme = 'nightfox' },
          { name = 'Tokyo Night', colorscheme = 'tokyonight' },
          { name = 'Nordfox', colorscheme = 'nordfox' },
          { name = 'Duskfox', colorscheme = 'duskfox' },
          { name = 'Terafox', colorscheme = 'terafox' },
          { name = 'Carbonfox', colorscheme = 'carbonfox' },
        },
        livePreview = true,
      })
    end,
    keys = {
      { '<leader>ut', '<cmd>Themery<cr>', desc = 'Theme Picker' },
    },
  },
}
