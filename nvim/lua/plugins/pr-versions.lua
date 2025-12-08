-- Configuration pour la gestion des PR avec comparaison de versions
-- À placer dans votre config Neovim (init.lua ou un fichier séparé)

local M = {}

-- Fonction pour extraire les versions du template
local function extract_versions_from_template()
  local template_path = vim.fn.getcwd() .. '/.developer/pull_request_template.md'
  if vim.fn.filereadable(template_path) == 0 then
    return nil, 'Template non trouvé'
  end

  local template = vim.fn.readfile(template_path)

  local versions = {
    api = nil,
    ui = nil,
  }

  local in_api = false
  local in_ui = false

  for _, line in ipairs(template) do
    -- Détecter les sections
    if line:match('##%s*🐍API:') then
      in_api = true
      in_ui = false
    elseif line:match('##%s*🎨UI:') then
      in_ui = true
      in_api = false
    elseif line:match('##') then
      in_api = false
      in_ui = false
    end

    -- Extraire les versions
    local version = line:match('^%s*%-%s*(%d+%.%d+%.%d+)')
    if version then
      if in_api then
        versions.api = version
      elseif in_ui then
        versions.ui = version
      end
    end
  end

  return versions
end

-- Fonction pour obtenir la dernière version et les commits depuis une version donnée
local function get_commits_since_version(repo_path, from_version)
  -- D'abord, trouver le commit qui arrive À la version from_version
  local find_commit_cmd = string.format(
    [[cd %s && git log --oneline --grep="chore(version):" --pretty=format:"%%H %%s" | grep "→ %s" | head -1 | cut -d' ' -f1]],
    repo_path,
    from_version
  )

  local from_commit = vim.fn.system(find_commit_cmd):gsub('%s+', '')

  if from_commit == '' then
    -- Si on ne trouve pas le commit exact, essayer de trouver le tag
    find_commit_cmd = string.format(
      [[cd %s && git rev-list -n 1 %s 2>/dev/null || git rev-list -n 1 v%s 2>/dev/null]],
      repo_path,
      from_version,
      from_version
    )
    from_commit = vim.fn.system(find_commit_cmd):gsub('%s+', '')
  end

  if from_commit == '' then
    return nil, nil, 'Version ' .. from_version .. ' non trouvée'
  end

  -- Obtenir tous les commits depuis ce commit (sans l'inclure)
  local get_commits_cmd =
    string.format([[cd %s && git log %s..HEAD --oneline --pretty=format:"%%s"]], repo_path, from_commit)

  local commits_output = vim.fn.system(get_commits_cmd)
  local commits = vim.split(commits_output, '\n', { plain = true, trimempty = true })

  -- Trouver la dernière version
  local get_latest_version_cmd = string.format(
    [[cd %s && git log -1 --grep="chore(version):" --pretty=format:"%%s" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+$"]],
    repo_path
  )

  local latest_version = vim.fn.system(get_latest_version_cmd):gsub('%s+', '')

  -- Si pas de commit chore(version), prendre depuis le tag
  if latest_version == '' then
    get_latest_version_cmd =
      string.format([[cd %s && git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//']], repo_path)
    latest_version = vim.fn.system(get_latest_version_cmd):gsub('%s+', '')
  end

  return commits, latest_version, nil
end

-- Fonction pour mettre à jour le template
local function update_template_with_commits()
  local cwd = vim.fn.getcwd()
  if not cwd:match('/infrastructure/?$') then
    vim.notify('⚠️  Vous devez être dans le dossier infrastructure/', vim.log.levels.WARN)
    return
  end

  -- Extraire les versions actuelles du template
  local template_versions, err = extract_versions_from_template()
  if not template_versions then
    vim.notify('❌ ' .. err, vim.log.levels.ERROR)
    return
  end

  if not template_versions.api and not template_versions.ui then
    vim.notify('❌ Aucune version trouvée dans le template', vim.log.levels.ERROR)
    return
  end

  -- Chemins des repos
  local api_path = vim.fn.fnamemodify(cwd, ':h') .. '/highcast-api'
  local ui_path = vim.fn.fnamemodify(cwd, ':h') .. '/highcast-ui'

  -- Collecter les informations pour chaque repo
  local updates = {}

  -- API
  if template_versions.api and vim.fn.isdirectory(api_path) == 1 then
    local commits, latest_version, error = get_commits_since_version(api_path, template_versions.api)
    if commits and latest_version and latest_version ~= template_versions.api then
      updates.api = {
        old_version = template_versions.api,
        new_version = latest_version,
        commits = commits,
      }
    elseif error then
      vim.notify('⚠️  API: ' .. error, vim.log.levels.WARN)
    end
  end

  -- UI
  if template_versions.ui and vim.fn.isdirectory(ui_path) == 1 then
    local commits, latest_version, error = get_commits_since_version(ui_path, template_versions.ui)
    if commits and latest_version and latest_version ~= template_versions.ui then
      updates.ui = {
        old_version = template_versions.ui,
        new_version = latest_version,
        commits = commits,
      }
    elseif error then
      vim.notify('⚠️  UI: ' .. error, vim.log.levels.WARN)
    end
  end

  -- Si pas de mises à jour
  if not updates.api and not updates.ui then
    vim.notify('✅ Le template est déjà à jour', vim.log.levels.INFO)
    return
  end

  -- Lire le template actuel
  local template_path = '.developer/pull_request_template.md'
  local lines = vim.fn.readfile(template_path)
  local new_lines = {}

  local in_api = false
  local in_ui = false
  local in_deployment = false
  local skip_until_next_section = false

  for i, line in ipairs(lines) do
    -- Détecter les sections
    if line:match('##%s*🐍API:') then
      in_api = true
      in_ui = false
      in_deployment = false
      skip_until_next_section = false
      table.insert(new_lines, line)

      -- Ajouter la nouvelle version et les commits
      if updates.api then
        table.insert(new_lines, '- ' .. updates.api.new_version)
        if #updates.api.commits > 0 then
          table.insert(new_lines, '')
          table.insert(new_lines, '### Changements:')
          for _, commit in ipairs(updates.api.commits) do
            -- Nettoyer le message de commit (enlever les préfixes type feat:, fix:, etc.)
            local clean_commit = commit:gsub('^%w+:%s*', '')
            -- Remplacer (#xxx) par le lien Markdown [#xxx](url) pour API
            clean_commit = clean_commit:gsub('%(#(%d+)%)', '[#%1](https://github.com/highcast-co/highcast-api/pull/%1)')
            table.insert(new_lines, '- ' .. clean_commit)
          end
        end
        skip_until_next_section = true
      end
    elseif line:match('##%s*🎨UI:') then
      in_api = false
      in_ui = true
      in_deployment = false
      skip_until_next_section = false
      table.insert(new_lines, '')
      table.insert(new_lines, line)

      -- Ajouter la nouvelle version et les commits
      if updates.ui then
        table.insert(new_lines, '- ' .. updates.ui.new_version)
        if #updates.ui.commits > 0 then
          table.insert(new_lines, '')
          table.insert(new_lines, '### Changements:')
          for _, commit in ipairs(updates.ui.commits) do
            -- Nettoyer le message de commit
            local clean_commit = commit:gsub('^%w+:%s*', '')
            -- Remplacer (#xxx) par le lien Markdown [#xxx](url) pour UI
            clean_commit = clean_commit:gsub('%(#(%d+)%)', '[#%1](https://github.com/highcast-co/highcast-ui/pull/%1)')
            table.insert(new_lines, '- ' .. clean_commit)
          end
        end
        skip_until_next_section = true
      end
    elseif line:match('##%s*Deployment Targets') then
      in_api = false
      in_ui = false
      in_deployment = true
      skip_until_next_section = false
      table.insert(new_lines, '')
      table.insert(new_lines, line)
    elseif line:match('##') then
      -- Autre section
      in_api = false
      in_ui = false
      in_deployment = false
      skip_until_next_section = false
      table.insert(new_lines, '')
      table.insert(new_lines, line)
    elseif not skip_until_next_section then
      -- Garder les lignes existantes si on n'est pas en train de les remplacer
      if not ((in_api and updates.api) or (in_ui and updates.ui)) then
        table.insert(new_lines, line)
      end
    end
  end

  -- Écrire le nouveau template
  vim.fn.writefile(new_lines, template_path)

  -- Message de confirmation
  local msg = '✅ Template mis à jour:\n'
  if updates.api then
    msg = msg
      .. string.format(
        '  🐍 API: %s → %s (%d commits)\n',
        updates.api.old_version,
        updates.api.new_version,
        #updates.api.commits
      )
  end
  if updates.ui then
    msg = msg
      .. string.format(
        '  🎨 UI: %s → %s (%d commits)',
        updates.ui.old_version,
        updates.ui.new_version,
        #updates.ui.commits
      )
  end

  vim.notify(msg, vim.log.levels.INFO)

  -- Ouvrir le template dans un nouveau buffer pour vérification
  vim.cmd('split ' .. template_path)
end

-- Fonction pour afficher un aperçu des changements
local function preview_changes()
  local cwd = vim.fn.getcwd()
  if not cwd:match('/infrastructure/?$') then
    vim.notify('⚠️  Vous devez être dans le dossier infrastructure/', vim.log.levels.WARN)
    return
  end

  local template_versions, err = extract_versions_from_template()
  if not template_versions then
    vim.notify('❌ ' .. err, vim.log.levels.ERROR)
    return
  end

  local api_path = vim.fn.fnamemodify(cwd, ':h') .. '/highcast-api'
  local ui_path = vim.fn.fnamemodify(cwd, ':h') .. '/highcast-ui'

  -- Créer un buffer de preview
  vim.cmd('new')
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_name(buf, 'PR Changes Preview')

  local lines = {}
  table.insert(lines, '=' .. string.rep('=', 70))
  table.insert(lines, '📋 CHANGEMENTS DEPUIS LES VERSIONS DU TEMPLATE')
  table.insert(lines, '=' .. string.rep('=', 70))
  table.insert(lines, '')

  -- API Changes
  if template_versions.api and vim.fn.isdirectory(api_path) == 1 then
    local commits, latest_version, error = get_commits_since_version(api_path, template_versions.api)

    table.insert(lines, '🐍 API')
    table.insert(lines, string.rep('-', 70))
    table.insert(lines, string.format('Version actuelle: %s', template_versions.api))

    if latest_version then
      table.insert(lines, string.format('Dernière version: %s', latest_version))
      table.insert(lines, '')

      if commits and #commits > 0 then
        table.insert(lines, 'Commits:')
        for _, commit in ipairs(commits) do
          -- Remplacer (#xxx) par PR #xxx pour la preview (plus lisible)
          local display_commit = commit:gsub('%(#(%d+)%)', '(PR #%1)')
          table.insert(lines, '  • ' .. display_commit)
        end
      else
        table.insert(lines, 'Aucun changement')
      end
    elseif error then
      table.insert(lines, 'Erreur: ' .. error)
    end
    table.insert(lines, '')
  end

  -- UI Changes
  if template_versions.ui and vim.fn.isdirectory(ui_path) == 1 then
    local commits, latest_version, error = get_commits_since_version(ui_path, template_versions.ui)

    table.insert(lines, '🎨 UI')
    table.insert(lines, string.rep('-', 70))
    table.insert(lines, string.format('Version actuelle: %s', template_versions.ui))

    if latest_version then
      table.insert(lines, string.format('Dernière version: %s', latest_version))
      table.insert(lines, '')

      if commits and #commits > 0 then
        table.insert(lines, 'Commits:')
        for _, commit in ipairs(commits) do
          -- Remplacer (#xxx) par PR #xxx pour la preview (plus lisible)
          local display_commit = commit:gsub('%(#(%d+)%)', '(PR #%1)')
          table.insert(lines, '  • ' .. display_commit)
        end
      else
        table.insert(lines, 'Aucun changement')
      end
    elseif error then
      table.insert(lines, 'Erreur: ' .. error)
    end
    table.insert(lines, '')
  end

  table.insert(lines, '=' .. string.rep('=', 70))
  table.insert(lines, 'Commandes disponibles:')
  table.insert(lines, '  <leader>gpu : Mettre à jour le template avec ces changements')
  table.insert(lines, '  q : Fermer cette fenêtre')
  table.insert(lines, '=' .. string.rep('=', 70))

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Keymaps locaux
  vim.keymap.set('n', 'q', ':close<CR>', { buffer = buf, silent = true })
  vim.keymap.set('n', '<leader>gpu', function()
    vim.cmd('close')
    update_template_with_commits()
  end, { buffer = buf, desc = 'Update template' })
end

-- Keymaps
vim.keymap.set('n', '<leader>gpd', preview_changes, { desc = 'GitHub: Preview PR changes' })
vim.keymap.set('n', '<leader>gpu', update_template_with_commits, { desc = 'GitHub: Update template with commits' })

-- Keymap pour créer la PR
vim.keymap.set('n', '<leader>gpp', function()
  local template_path = '.developer/pull_request_template.md'
  local cmd

  if vim.fn.filereadable(template_path) == 1 then
    -- Lire le template
    local template_lines = vim.fn.readfile(template_path)
    local tmp_file = vim.fn.tempname()
    vim.fn.writefile(template_lines, tmp_file)

    -- Utiliser le fichier temporaire comme body
    cmd = string.format('gh pr create --web --body-file "%s"', tmp_file)
    vim.fn.system(cmd)

    -- Nettoyer le fichier temporaire
    vim.fn.delete(tmp_file)
  else
    -- Si aucun template n’est trouvé, créer simplement la PR sans body
    vim.notify('ℹ️ Aucun template trouvé, création de PR sans body', vim.log.levels.INFO)
    vim.fn.system('gh pr create --web')
  end
end, { desc = 'GitHub: Create PR with template or fallback' })

return M
