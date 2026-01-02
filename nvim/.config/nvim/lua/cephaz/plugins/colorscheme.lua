return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    style = 'night', -- Essaye "storm" si tu veux plus de contraste
    transparent = false,
    styles = {
      sidebars = 'dark', -- Assombrit l'explorateur de fichiers pour le détacher
      floats = 'dark',
    },
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd 'colorscheme tokyonight'
  end,
}
