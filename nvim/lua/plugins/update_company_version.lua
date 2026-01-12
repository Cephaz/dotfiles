return {
  {
    'company-changelog',
    dir = vim.fn.stdpath('config'),
    config = function()
      local function update_changelog(repos_to_update)
        local template_path = '.developer/pull_request_template.md'
        local org_name = 'highcast-co' -- À MODIFIER
        local base_url = 'https://github.com/' .. org_name .. '/'

        -- 1. TABLE DE CORRESPONDANCE (Plus rapide et fiable)
        -- Ajoutez ici les noms Git et les pseudos GitHub correspondants
        local NAME_MAP = {
          ['Pierre ZHOU'] = 'Cephaz', -- <-- METTEZ VOTRE PSEUDO ICI
          ['Flore de Lasteyrie'] = 'floredelasteyrie',
          ['eric-highcast'] = 'eric-highcast',
          ['shanti-highcast'] = 'shanti-highcast',
          ['Henrique'] = 'henrique-britoleao',
        }

        local handle_cache = {}

        local function get_github_handle(repo, pr_num, git_name)
          -- Priorité 1 : Le dictionnaire manuel
          if NAME_MAP[git_name] then
            return NAME_MAP[git_name]
          end

          -- Priorité 2 : Le cache de session
          if pr_num and handle_cache[pr_num] then
            return handle_cache[pr_num]
          end

          -- Priorité 3 : Appel à GitHub CLI (si PR détectée)
          if pr_num then
            local cmd = string.format(
              'gh pr view %s -R %s/%s --json author --jq .author.login 2>/dev/null',
              pr_num,
              org_name,
              repo
            )
            local f = io.popen(cmd)
            local result = f:read('*a'):gsub('%s+', '')
            f:close()

            if result ~= '' then
              handle_cache[pr_num] = result
              return result
            end
          end

          -- Fallback : On retire les espaces pour essayer de créer un tag plausible
          return git_name:gsub('%s+', '')
        end

        -- [LECTURE DU FICHIER]
        local f_read = io.open(template_path, 'r')
        if not f_read then
          return
        end
        local content = f_read:read('*a')
        f_read:close()

        local function get_existing_section(label)
          local pattern = '(## [^\n]*' .. label .. '.-)\n##'
          local block = content:match(pattern) or content:match('(## [^\n]*' .. label .. '.*)')
          if block then
            local footer_idx = block:find('\n## 🧪 Testé')
            if footer_idx then
              block = block:sub(1, footer_idx - 1)
            end
            return vim.trim(block)
          end
          return nil
        end

        local footer_start = content:find('## 🧪 Testé')
        local footer = footer_start and content:sub(footer_start) or '## 🧪 Testé / déployé\n...'

        local all_repos = {
          { id = 'api', name = 'highcast-api', icon = '🐍', label = 'Updates API' },
          { id = 'ui', name = 'highcast-ui', icon = '🎨', label = 'Updates UI' },
        }

        local final_sections = { '# 🚀 Release Report', '' }

        for _, repo_info in ipairs(all_repos) do
          local is_targeted = false
          for _, r_name in ipairs(repos_to_update) do
            if r_name == repo_info.name then
              is_targeted = true
            end
          end

          if is_targeted then
            local current_v = content:match(repo_info.label .. ' %- (%d+%.%d+%.%d+)') or '0.0.0'
            local latest_v_found = nil
            local repo_lines = {}

            local cmd =
              string.format("git -C ../%s log master --pretty=format:'%%h|%%an|%%s' -n 50 2>/dev/null", repo_info.name)
            local git_handle = io.popen(cmd)
            local git_logs = {}
            if git_handle then
              for l in git_handle:lines() do
                table.insert(git_logs, l)
              end
              git_handle:close()
            end

            for i, line in ipairs(git_logs) do
              local hash, author_git, title = line:match('([^|]+)|([^|]+)|([^|]+)')
              local v_from, v_to = title:match('([%d%.]+)%s*→%s*([%d%.]+)')

              if v_from and v_to then
                if v_to == current_v then
                  break
                end
                if not latest_v_found then
                  latest_v_found = v_to
                end

                local parent_line = git_logs[i + 1]
                if parent_line then
                  local p_hash, p_author_git, p_title = parent_line:match('([^|]+)|([^|]+)|([^|]+)')
                  local pr_num = p_title:match('#(%d+)')

                  -- RÉCUPÉRATION DU PSEUDO (Dictionnaire -> GitHub CLI -> Git Name)
                  local github_handle = get_github_handle(repo_info.name, pr_num, p_author_git)

                  local link = pr_num and (base_url .. repo_info.name .. '/pull/' .. pr_num)
                    or (base_url .. repo_info.name .. '/commit/' .. p_hash)
                  local clean_title = p_title:gsub(' %((#%d+)%)$', ''):gsub(' %(#%d+%)$', '')

                  table.insert(
                    repo_lines,
                    string.format('- `%s → %s` = [%s](%s) @%s', v_from, v_to, clean_title, link, github_handle)
                  )
                end
              end
            end

            table.insert(
              final_sections,
              string.format('## %s %s - %s', repo_info.icon, repo_info.label, latest_v_found or current_v)
            )
            if #repo_lines > 0 then
              for _, rl in ipairs(repo_lines) do
                table.insert(final_sections, rl)
              end
            else
              table.insert(final_sections, '_Aucun nouvel update_')
            end
          else
            local existing = get_existing_section(repo_info.label)
            if existing then
              table.insert(final_sections, existing)
            end
          end
          table.insert(final_sections, '')
        end

        local full_content = table.concat(final_sections, '\n'):gsub('\n\n\n', '\n\n') .. '\n' .. footer
        local f_write = io.open(template_path, 'w')
        if f_write then
          f_write:write(full_content)
          f_write:close()
          vim.cmd('edit ' .. template_path)
          vim.notify('✅ Changements appliqués avec pseudos GitHub', vim.log.levels.INFO)
        end
      end

      -- MAPPINGS
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>gpu', function()
        update_changelog({ 'highcast-api', 'highcast-ui' })
      end, opts)
      vim.keymap.set('n', '<leader>gpb', function()
        update_changelog({ 'highcast-api' })
      end, opts)
      vim.keymap.set('n', '<leader>gpf', function()
        update_changelog({ 'highcast-ui' })
      end, opts)
    end,
  },
}
