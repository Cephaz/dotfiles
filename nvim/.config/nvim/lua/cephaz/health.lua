local M = {}

function M.check()
  vim.health.start 'Neovim 0.12 — dépendances externes'
  if vim.fn.has 'nvim-0.12' == 1 then
    vim.health.ok 'Neovim >= 0.12'
  else
    vim.health.error 'Neovim >= 0.12 requis'
  end

  for _, command in ipairs {
    'git',
    'cc',
    'tree-sitter',
    'node',
    'lua-language-server',
    'vtsls',
    'vue-language-server',
    'pyright-langserver',
    'rust-analyzer',
    'stylua',
    'prettier',
    'eslint_d',
    'flake8',
    'isort',
    'black',
    'rustfmt',
    'glow',
    'rg',
    'fd',
  } do
    if vim.fn.executable(command) == 1 then
      local path = vim.fn.exepath(command)
      if path:find('/mason/', 1, true) then
        vim.health.warn(
          command .. ' dépend encore de Mason : ' .. path,
          { 'Installer la version système : voir nvim/README.md.' }
        )
      else
        vim.health.ok(command .. ' : ' .. path)
      end
    else
      vim.health.warn(
        command .. ' absent du PATH',
        { 'Voir les commandes dans nvim/README.md puis relancer Neovim.' }
      )
    end
  end
end

return M
