# Neovim 0.12+

## Installation des outils (macOS)

Mason existe toujours, mais n'est plus utilisé ici. Le client LSP natif ne
télécharge pas les serveurs, formateurs ou linters : il faut les installer.
Depuis un terminal avec la version Node souhaitée active (`nvm use default`) :

```sh
xcode-select --install # uniquement si les Command Line Tools sont absents
brew install neovim lua-language-server stylua taplo tree-sitter-cli glow ripgrep fd pipx rustup
npm install -g @vtsls/language-server @vue/language-server @vue/typescript-plugin typescript pyright prettier eslint_d
pipx install black
pipx install isort
pipx install flake8
pipx ensurepath
rustup toolchain install stable
rustup component add --toolchain stable rust-analyzer rustfmt
```

Ajouter le répertoire `bin` de Rustup au PATH selon les instructions Homebrew,
ainsi que `~/.local/bin` pour pipx. Si aucun toolchain Rust par défaut n'est
configuré, exécuter `rustup default stable`. Les outils npm globaux sont propres
à chaque version Node avec nvm : les réinstaller après un changement de version.
Ne pas installer `tree-sitter-cli` via npm ; utiliser la formule Homebrew.

Ouvrir Neovim, lancer `:Lazy sync`, puis `:checkhealth cephaz` et `:checkhealth vim.lsp`.
Les parseurs Treesitter ne sont pas installés automatiquement ; lancer
`:TSInstall javascript typescript` (ou les autres parseurs souhaités) une fois.
`:TSUpdate` les met à jour.
Pour TOML, lancer `:TSInstall toml` : Taplo fournit les diagnostics LSP et le
formatage à la sauvegarde, sans linter supplémentaire.
Les serveurs absents du PATH ne sont pas activés : les installer puis relancer
Neovim. Les anciens exécutables Mason ne sont pas supprimés de la machine.

Vue utilise le chemin réel de `vue-language-server` dans le PATH, plus un éventuel
override `NVIM_VUE_LANGUAGE_SERVER_PATH` pointant vers le dossier
`@vue/language-server`. La configuration hybride Vue + vtsls est conservée.

## Natif et plugins conservés

- Complétion LSP : `vim.lsp.completion`, sans nvim-cmp ni cmp-nvim-lsp.
- Snippets fournis par le LSP : `vim.snippet`, sans LuaSnip. Les collections
  friendly-snippets et leurs préfixes ne sont plus chargés.
- Complétion des buffers : `autocomplete` ; chemins : `<C-x><C-f>` ;
  commandes et recherche : complétion native avec `<Tab>`.
- Coloration et plis : `vim.treesitter` ; nvim-treesitter **main** fournit
  encore les parseurs, les queries et l'indentation.
- Lazy reste pour le chargement différé et les dépendances. `vim.pack` existe,
  mais ne remplace pas cette orchestration à lui seul.
- Conform, nvim-lint, Noice, Snacks, les sessions, Git et le sélecteur de venv
  restent : leurs fonctionnalités ne sont pas intégralement remplacées en 0.12.
- nvim-lspconfig fournit les définitions des serveurs ; activation exclusivement
  via `vim.lsp.config` / `vim.lsp.enable`, sans ancienne API `lspconfig.setup`.

## Raccourcis

- `<C-Space>` : suggestions LSP ; `<C-j>` / `<C-k>` : suivant / précédent.
- `<CR>` : valider seulement une suggestion sélectionnée ; `<C-y>` : valider ;
  `<C-e>` : fermer le menu.
- `<Tab>` / `<S-Tab>` : naviguer dans les champs d'un snippet LSP.
- `<leader>mp` : formater ; `<leader>pm` : aperçu Markdown (Glow).
- Les raccourcis LSP existants sont conservés, dont `<leader>rs` pour redémarrer
  les serveurs du buffer via l'API native.
