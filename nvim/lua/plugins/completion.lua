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
      -- Support TypeScript et Vue
      'hrsh7th/cmp-nvim-lsp-signature-help', -- Aide aux signatures de fonctions
      'hrsh7th/cmp-nvim-lua', -- Complétion pour Lua/Neovim
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      -- Charger les snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      -- Charger les snippets spécifiques à TypeScript et Vue
      require('luasnip.loaders.from_vscode').lazy_load({
        include = { 'typescript', 'javascript', 'vue', 'html', 'css' },
      })

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
          { name = 'nvim_lsp_signature_help', priority = 950 }, -- Aide signatures
          { name = 'luasnip', priority = 750 }, -- Snippets
          { name = 'buffer', priority = 500 }, -- Mots du buffer
          { name = 'path', priority = 250 }, -- Chemins de fichiers
          { name = 'nvim_lua', priority = 200 }, -- Complétion Lua pour config Neovim
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Icônes pour les différentes sources
            local icons = {
              nvim_lsp = '🔧',
              nvim_lsp_signature_help = '📋',
              luasnip = '📄',
              buffer = '📝',
              path = '📁',
              nvim_lua = '🌙',
            }
            vim_item.kind = (icons[entry.source.name] or '❓') .. ' ' .. vim_item.kind
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              nvim_lsp_signature_help = '[Signature]',
              luasnip = '[Snippet]',
              buffer = '[Buffer]',
              path = '[Path]',
              nvim_lua = '[Lua]',
            })[entry.source.name]
            return vim_item
          end,
        },
        -- Configuration spécifique pour les fichiers TypeScript et Vue
        filetype = {
          typescript = {
            sources = cmp.config.sources({
              { name = 'nvim_lsp', priority = 1000 },
              { name = 'nvim_lsp_signature_help', priority = 950 },
              { name = 'luasnip', priority = 750 },
              { name = 'buffer', priority = 500 },
              { name = 'path', priority = 250 },
            }),
          },
          vue = {
            sources = cmp.config.sources({
              { name = 'nvim_lsp', priority = 1000 },
              { name = 'nvim_lsp_signature_help', priority = 950 },
              { name = 'luasnip', priority = 750 },
              { name = 'buffer', priority = 500 },
              { name = 'path', priority = 250 },
            }),
          },
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

  -- Mason pour installer les serveurs de langue TypeScript et Vue
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Serveurs de langue pour TypeScript et Vue
        'typescript-language-server', -- LSP pour TypeScript/JavaScript
        'vue-language-server', -- Serveur de langue Vue alternatif
        -- Outils de formatage et linting
        'prettier', -- Formatage pour TS/JS/Vue
        'eslint-lsp', -- Linting ESLint
      })
    end,
  },

  -- Configuration LSP pour TypeScript et Vue
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Configuration pour TypeScript
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        -- Configuration pour Vue.js (Volar)
        volar = {
          filetypes = {
            'typescript',
            'javascript',
            'javascriptreact',
            'typescriptreact',
            'vue',
            'json',
          },
          init_options = {
            vue = {
              hybridMode = false,
            },
            typescript = {
              tsdk = vim.fn.getcwd() .. '/node_modules/typescript/lib',
            },
          },
          settings = {
            vue = {
              inlayHints = {
                missingProps = true,
                inlineHandlerLeading = true,
                optionsWrapper = true,
                destructuredProps = true,
              },
            },
          },
        },
      },
    },
  },
}
