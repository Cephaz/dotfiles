return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  keys = {
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Épingler le buffer' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Fermer les buffers non-épinglés' },
    { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Fermer les autres buffers' },
    { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Fermer les buffers à droite' },
    { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Fermer les buffers à gauche' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Buffer précédent' },
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Buffer suivant' },
    { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Déplacer buffer à gauche' },
    { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Déplacer buffer à droite' },
  },
  opts = {
    options = {
      -- Style des onglets
      mode = 'buffers', -- set to "tabs" to only show tabpages instead
      themable = true,

      -- Comportement de fermeture
      close_command = 'bdelete! %d',
      right_mouse_command = 'bdelete! %d',
      left_mouse_command = 'buffer %d',
      middle_mouse_command = nil,

      -- Indicateurs
      indicator = {
        icon = '▎',
        style = 'icon',
      },

      -- Icônes
      buffer_close_icon = '󰅖',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',

      -- Numérotation
      numbers = 'none', -- "none" | "ordinal" | "buffer_id" | "both"

      -- Largeur des noms
      max_name_length = 18,
      max_prefix_length = 15,
      truncate_names = true,
      tab_size = 18,

      -- Diagnostics LSP
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match('error') and ' ' or ' '
        return ' ' .. icon .. count
      end,

      -- Séparateurs
      separator_style = 'thin', -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }

      -- Affichage conditionnel
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,

      -- Ordre de tri
      sort_by = 'insert_after_current',

      -- Buffers à ne pas afficher
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Explorateur',
          text_align = 'center',
          separator = true,
        },
        {
          filetype = 'NvimTree',
          text = 'Explorateur',
          text_align = 'center',
          separator = true,
        },
      },

      -- Groupes personnalisés (optionnel)
      groups = {
        options = {
          toggle_hidden_on_enter = true,
        },
        items = {
          {
            name = 'Tests',
            highlight = { underline = true, sp = 'blue' },
            priority = 2,
            icon = '',
            matcher = function(buf)
              return buf.name:match('_spec') or buf.name:match('_test')
            end,
          },
          {
            name = 'Docs',
            highlight = { underline = true, sp = 'green' },
            auto_close = false,
            matcher = function(buf)
              return buf.name:match('%.md') or buf.name:match('%.txt')
            end,
          },
        },
      },

      -- Hover pour voir le chemin complet
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
    },
  },
  config = function(_, opts)
    require('bufferline').setup(opts)

    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
