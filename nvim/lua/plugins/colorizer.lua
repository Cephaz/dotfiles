return {
  'NvChad/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({
      user_default_options = {
        names = false, -- Désactive la détection des noms de couleurs ("red", "blue", etc.)
        RRGGBBAA = true, -- Supporte les couleurs avec transparence (#RRGGBBAA)
        rgb_fn = true, -- Supporte `rgb(255, 0, 0)`
        hsl_fn = true, -- Supporte `hsl(120, 100%, 50%)`
        css = true, -- Active pour CSS
        css_fn = true, -- Active les fonctions CSS comme `rgba()`
        tailwind = true, -- Supporte Tailwind CSS
        mode = 'background', -- Affiche la couleur en arrière-plan
      },
    })
  end,
}
