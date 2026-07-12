return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      notify = {
        enabled = false,
      },
      messages = {
        enabled = true,
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      bufdelete = { enabled = true },
      winbar = { enabled = true },
      indent = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          {
            section = 'projects',
            icon = ' ',
            title = 'Projets Récents',
            padding = 1,
            limit = 5,
            action = function(dir)
              vim.api.nvim_set_current_dir(dir)
              require('persistence').load { last = false }
              vim.schedule(function()
                local buffers = vim.api.nvim_list_bufs()
                for _, bufnr in ipairs(buffers) do
                  if vim.api.nvim_buf_get_name(bufnr) == '' and vim.api.nvim_get_option_value('buftype', { buf = bufnr }) == '' then
                    vim.api.nvim_buf_delete(bufnr, { force = true })
                  end
                end
              end)
            end,
          },
          {
            section = 'recent_files',
            icon = ' ',
            title = 'Fichiers Récents',
            padding = 1,
            indent = 2,
            limit = 5,
          },
        },
      },
      notifier = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      input = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      scope = { enabled = true },
      lazygit = { enabled = true },
      terminal = { enabled = true },
      gitbrowse = { enabled = true },
      picker = {
        enabled = true,
        icons = {
          git = {
            added = ' ',
            modified = ' ',
            deleted = ' ',
            renamed = ' ',
            untracked = ' ',
            ignored = ' ',
            staged = ' ',
          },
        },
      },
    },
    keys = {
      {
        '<leader>e',
        function()
          require('snacks').explorer()
        end,
        desc = 'File Explorer',
      },
      {
        '<leader>bd',
        function()
          require('snacks').bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>bo',
        function()
          require('snacks').bufdelete.other()
        end,
        desc = 'Delete Other Buffers',
      },
      {
        '<leader>gg',
        function()
          require('snacks').lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>go',
        function()
          require('snacks').gitbrowse()
        end,
        desc = 'Open on GitHub',
      },
      {
        '<c-/>',
        function()
          require('snacks').terminal.toggle(nil, {
            win = { position = 'float', border = 'rounded' },
          })
        end,
        desc = 'Toggle Terminal',
        mode = { 'n', 't' },
      },
      {
        '<leader>ff',
        function()
          require('snacks').picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>fg',
        function()
          require('snacks').picker.grep()
        end,
        desc = 'Grep Text',
      },
      {
        '<leader>bb',
        function()
          require('snacks').picker.buffers()
        end,
        desc = 'Find Buffers',
      },
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = 'Goto Definition',
      },
      {
        'gR',
        function()
          Snacks.picker.lsp_references()
        end,
        desc = 'References',
      },
      {
        'gi',
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = 'Goto Implementation',
      },
      {
        'gt',
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = 'Goto Type Definition',
      },
      {
        '<leader>D',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = 'Buffer Diagnostics',
      },
    },
  },
}
