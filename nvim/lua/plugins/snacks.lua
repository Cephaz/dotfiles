return {
    {
        "folke/snacks.nvim",
        lazy         = false,
        priority     = 1000,
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        opts         = {
            -- HACK: read picker docs @ https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
            picker = {
                enabled = true,
                matchers = {
                    frecency = true,
                    cwd_bonus = false,
                },
                formatters = {
                    file = {
                        filename_first = false,
                        filename_only = false,
                        icon_width = 2,
                    },
                },
                layout = {
                    -- presets options : "default" , "ivy" , "ivy-split" , "telescope" , "vscode", "select" , "sidebar"
                    -- override picker layout in keymaps function as a param below
                    preset = "telescope", -- defaults to this layout unless overidden
                    cycle = false,
                },
                layouts = {
                    select = {
                        preview = false,
                        layout = {
                            backdrop = false,
                            width = 0.6,
                            min_width = 80,
                            height = 0.4,
                            min_height = 10,
                            box = "vertical",
                            border = "rounded",
                            title = "{title}",
                            title_pos = "center",
                            { win = "input",   height = 1,          border = "bottom" },
                            { win = "list",    border = "none" },
                            { win = "preview", title = "{preview}", width = 0.6,      height = 0.4, border = "top" },
                        }
                    },
                    telescope = {
                        reverse = true, -- set to false for search bar to be on top
                        layout = {
                            box = "horizontal",
                            backdrop = false,
                            width = 0.8,
                            height = 0.9,
                            border = "none",
                            {
                                box = "vertical",
                                { win = "list",  title = " Results ", title_pos = "center", border = "rounded" },
                                { win = "input", height = 1,          border = "rounded",   title = "{title} {live} {flags}", title_pos = "center" },
                            },
                            {
                                win = "preview",
                                title = "{preview:Preview}",
                                width = 0.50,
                                border = "rounded",
                                title_pos = "center",
                            },
                        },
                    },
                    ivy = {
                        layout = {
                            box = "vertical",
                            backdrop = false,
                            width = 0,
                            height = 0.4,
                            position = "bottom",
                            border = "top",
                            title = " {title} {live} {flags}",
                            title_pos = "left",
                            { win = "input", height = 1, border = "bottom" },
                            {
                                box = "horizontal",
                                { win = "list",    border = "none" },
                                { win = "preview", title = "{preview}", width = 0.5, border = "left" },
                            },
                        },
                    },
                }
            },
            dashboard = {
                enabled = true,
                sections = {
                    { section = "header" },
                    { section = "keys",  gap = 1, padding = 1 },
                    {
                        pane    = 2,
                        icon    = " ",
                        title   = "Recent Files",
                        section = "recent_files",
                        indent  = 2,
                        padding = 1,
                    },
                    {
                        pane    = 2,
                        icon    = " ",
                        title   = "Projects",
                        section = "projects",
                        indent  = 2,
                        padding = 1,
                    },
                    {
                        pane    = 2,
                        icon    = " ",
                        title   = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return require("snacks.git").get_root() ~= nil
                        end,
                        cmd     = "git status --short --branch --renames",
                        height  = 5,
                        padding = 1,
                        ttl     = 5 * 60,
                        indent  = 3,
                    },
                    { section = "startup" },
                },
            },
        },
        keys         = {
            { "<leader>gg",  function() require("snacks").lazygit() end,                               desc = "Lazygit" },
            { "<leader>gl",  function() require("snacks").lazygit.log() end,                           desc = "Lazygit Logs" },
            { "<leaderff",   function() require("snacks").picker.files() end,                          desc = "Find Files (Snacks Picker)" },
            { "<leader>fg",  function() require("snacks").picker.grep() end,                           desc = "Grep word" },
            { "<leader>pk",  function() require("snacks").picker.keymaps({ layout = "ivy" }) end,      desc = "Search Keymaps (Snacks Picker)" },
            { "<leader>th",  function() require("snacks").picker.colorschemes({ layout = "ivy" }) end, desc = "Pick Color Schemes" },
        },
    },

    {
        "folke/persistence.nvim",
        event  = "BufReadPre",
        config = function()
            require("persistence").setup({
                dir     = vim.fn.stdpath("state") .. "/sessions/",
                options = { "buffers", "curdir", "tabpages", "winsize" },
            })
        end,
    },
}
