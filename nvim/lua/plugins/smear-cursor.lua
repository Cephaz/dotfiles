return {
  {
    'sphamba/smear-cursor.nvim',
    config = function()
      require('smear_cursor').setup({
        -- Apparence
        cursor_color = '#d3cdc3',
        stiffness = 0.8, -- Rigidité de l'effet (0.1-1)
        trailing_stiffness = 0.5, -- Rigidité de la traînée
        distance_weighting_pow = 1.5,
        max_smear_percent = 130,

        -- Comportement
        on_filter_scrollarea = function() end,
      })
    end,
  },
}
