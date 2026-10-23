# Install order

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install --cask font-jetbrains-mono-nerd-font
brew install wezterm tmux neovim lazygit opencode fzf gh wget fd ast-grep imagemagick rustup go gum

brew install pyenv pipx openssl@3
brew install nvm

brew install --cask docker

# Install node

nvm install 26
nvm alias default 26
nvm use 26

npm install -g corepack
corepack enable

# Install GCP and python

PYTHON_BUILD_HOMEBREW_OPENSSL_FORMULA=openssl@3 \
pyenv install 3.12.9

pipx install poetry

poetry config virtualenvs.in-project true

brew install --cask gcloud-cli

pipx inject poetry keyring keyrings.google-artifactregistry-auth

# Update tmux

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ctrl + b + I

# 🛠 Dotfiles

macOS : **GNU Stow**

## 📁 Structure

```text
<name>/
└── .config/
    └── <name>/
        └── ...
```

## 🚀 Setup

```sh
stow -v -t ~ <name>
```
