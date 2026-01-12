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

  {
    'Shatur/neovim-ayu',
    lazy = false,
    priority = 1000,
    config = function()
      require('ayu').setup({
        overrides = function(colors)
          return {
            NonText = { fg = '#707A8C' },
          }
        end,
      })

      vim.cmd.colorscheme('ayu')
    end,
  },

  -- Theme Picker
  {
    'zaldih/themery.nvim',
    lazy = false,
    config = function()
      require('themery').setup({
        themes = {
          -- Nightfox family
          { name = 'Nightfox', colorscheme = 'nightfox' },
          { name = 'Nordfox', colorscheme = 'nordfox' },
          { name = 'Duskfox', colorscheme = 'duskfox' },
          { name = 'Terafox', colorscheme = 'terafox' },
          { name = 'Carbonfox', colorscheme = 'carbonfox' },
          -- Tokyo Night
          { name = 'Tokyo Night', colorscheme = 'tokyonight' },
          -- Ayu variants (Ajoutés)
          { name = 'Ayu Light', colorscheme = 'ayu-light' },
          { name = 'Ayu Dark', colorscheme = 'ayu-dark' },
          { name = 'Ayu Mirage', colorscheme = 'ayu-mirage' },
        },
        livePreview = true,
      })
    end,
    keys = {
      { '<leader>ut', '<cmd>Themery<cr>', desc = 'Theme Picker' },
    },
  },
}
