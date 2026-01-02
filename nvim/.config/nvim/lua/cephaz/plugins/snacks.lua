return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      -- === TES MODULES ACTUELS ===
      explorer = {
        enabled = true,
        replace_netrw = true,

        git_status_symbols = {
          added = '+',
          modified = '~',
          deleted = 'x',
        },
      },
      bufdelete = { enabled = true },
      winbar = { enabled = true },
      indent = { enabled = true }, -- Lignes d'indentation
      dashboard = { enabled = true }, -- Je simplifie la config ici pour la lisibilité
      notifier = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },

      -- === LES AJOUTS PERTINENTS ===

      -- 1. Interface Moderne
      input = { enabled = true }, -- Jolie fenêtre pour les inputs (rename, create file)
      scroll = { enabled = true }, -- Défilement fluide
      statuscolumn = { enabled = true }, -- Colonne de gauche propre (Git + Numéros)

      -- 2. Outils de Code
      words = { enabled = true }, -- Surligne les références du mot sous le curseur
      scope = { enabled = true }, -- Surligne le bloc de code actif (fonction/boucle)

      -- 3. Outils Système & Git
      lazygit = { enabled = true }, -- Interface Git
      terminal = { enabled = true }, -- Terminal flottant
      gitbrowse = { enabled = true }, -- Ouvrir le fichier actuel sur GitHub/GitLab

      -- 4. Recherche (Remplace Telescope)
      picker = { enabled = true },
    },

    keys = {
      -- === EXPLORATEUR & DASHBOARD ===
      {
        '<leader>e',
        function()
          Snacks.explorer()
        end,
        desc = 'Explorateur de fichiers',
      },
      {
        '<leader>d',
        function()
          Snacks.dashboard.open()
        end,
        desc = 'Dashboard',
      },

      -- === BUFFERS ===
      {
        '<leader>bd',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Fermer buffer',
      },
      {
        '<leader>bo',
        function()
          Snacks.bufdelete.other()
        end,
        desc = 'Fermer les autres buffers',
      },

      -- === GIT (Nouveau) ===
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>go',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Ouvrir sur GitHub',
      },

      -- === TERMINAL (Nouveau) ===
      -- C'est très pratique : Ctrl + / pour ouvrir un terminal
      {
        '<c-/>',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle Terminal',
        mode = { 'n', 't' },
      },

      -- === PICKER (Recherche - Nouveau) ===
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Chercher Fichiers',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Chercher Texte (Grep)',
      },
      {
        '<leader>bb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Liste des Buffers',
      },

      -- === UTILS ===
      {
        '<leader>z',
        function()
          Snacks.zen()
        end,
        desc = 'Mode Zen',
      },
    },
  },
}
