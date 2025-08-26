return {
    {
        "morhetz/gruvbox",
        lazy     = false, -- on veut charger le thème tout de suite
        priority = 1000, -- haute priorité pour qu’il soit dispo avant les autres plugins
        config   = function()
            -- options Gruvbox (ici mode sombre ‘hard’)
            vim.g.gruvbox_contrast_dark = "hard"
            -- applique le colorscheme
            vim.cmd([[colorscheme gruvbox]])
        end,
    },
}
