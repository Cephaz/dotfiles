return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Couleurs Catppuccin personnalisées
    local colors = {
      bg = '#1e1e2e',
      fg = '#cdd6f4',
      yellow = '#f9e2af',
      cyan = '#89dceb',
      darkblue = '#081633',
      green = '#a6e3a1',
      orange = '#fab387',
      violet = '#cba6f7',
      magenta = '#f5c2e7',
      blue = '#89b4fa',
      red = '#f38ba8',
      surface0 = '#313244',
      surface1 = '#45475a',
      surface2 = '#585b70',
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.violet },
        b = { fg = colors.fg, bg = colors.surface1 },
        c = { fg = colors.fg, bg = colors.surface0 },
      },

      insert = { a = { fg = colors.bg, bg = colors.blue } },
      visual = { a = { fg = colors.bg, bg = colors.cyan } },
      replace = { a = { fg = colors.bg, bg = colors.red } },

      inactive = {
        a = { fg = colors.fg, bg = colors.surface0 },
        b = { fg = colors.fg, bg = colors.surface0 },
        c = { fg = colors.fg, bg = colors.surface0 },
      },
    }

    require('lualine').setup({
      options = {
        theme = bubbles_theme,
        component_separators = '|',
        section_separators = { left = '', right = '' },
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          { 'mode', separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = {
          'filename',
          {
            'branch',
            icon = '',
            color = { fg = colors.violet },
          },
        },
        lualine_c = {
          {
            'diff',
            colored = true,
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.orange },
              removed = { fg = colors.red },
            },
            symbols = { added = '+', modified = '~', removed = '-' },
          },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            sections = { 'error', 'warn', 'info', 'hint' },
            diagnostics_color = {
              error = { fg = colors.red },
              warn = { fg = colors.yellow },
              info = { fg = colors.cyan },
              hint = { fg = colors.violet },
            },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = '💡' },
          },
        },
        lualine_x = {
          {
            'encoding',
            color = { fg = colors.green },
          },
          {
            'fileformat',
            symbols = {
              unix = '', -- e712
              dos = '', -- e70f
              mac = '', -- e711
            },
            color = { fg = colors.blue },
          },
          {
            'filetype',
            colored = true,
            color = { fg = colors.magenta },
          },
        },
        lualine_y = {
          {
            'progress',
            color = { fg = colors.orange },
          },
        },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {
        'neo-tree',
        'lazy',
        'mason',
        'trouble',
        'toggleterm',
      },
    })
  end,
}
