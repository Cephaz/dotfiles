return {
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    -- The app loader also requires msgpack-lite, missing from app/package.json.
    build = 'npm install --prefix app --no-save --omit=dev --no-package-lock --no-audit --no-fund msgpack-lite@0.1.26',
    keys = {
      {
        '<leader>mp',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown Preview',
        ft = 'markdown',
      },
    },
  },
}
