return {
  -- Moteur d'autocomplétion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- Complétion LSP
      'hrsh7th/cmp-buffer', -- Complétion buffer
      'hrsh7th/cmp-path', -- Complétion chemins
      'hrsh7th/cmp-cmdline', -- Complétion ligne de commande
      'L3MON4D3/LuaSnip', -- Moteur de snippets
      'saadparwaiz1/cmp_luasnip', -- Intégration LuaSnip avec cmp
      'rafamadriz/friendly-snippets', -- Collection de snippets
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- Charger les snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter pour accepter
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),

        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 }, -- LSP en priorité
          { name = 'luasnip', priority = 750 }, -- Snippets
          { name = 'buffer', priority = 500 }, -- Mots du buffer
          { name = 'path', priority = 250 }, -- Chemins de fichiers
        }),

        formatting = {
          format = function(entry, vim_item)
            -- Icônes pour les différentes sources
            local icons = {
              nvim_lsp = '🔧',
              luasnip = '📄',
              buffer = '📝',
              path = '📁',
            }
            vim_item.kind = (icons[entry.source.name] or '❓') .. ' ' .. vim_item.kind
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              buffer = '[Buffer]',
              path = '[Path]',
            })[entry.source.name]
            return vim_item
          end,
        },
      })

      -- Complétion pour la ligne de commande
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })

      -- Complétion pour la recherche
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })
    end,
  },

  -- Mason pour installer les outils de complétion si nécessaire
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Pas besoin d'installer des outils spéciaux pour cmp
      })
    end,
  },
}
