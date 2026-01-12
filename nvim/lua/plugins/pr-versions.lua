local M = {}

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
