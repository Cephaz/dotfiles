-- Explorer
return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- Ne pas lazy-loader pour que le mapping soit dispo tout le temps
        lazy = false,
        config = function()
            require("nvim-tree").setup({
                hijack_netrw = true,
                update_cwd   = true,
                view         = { width = 30, side = "left" },
                actions      = {
                    open_file = {
                        resize_window = false,
                        window_picker = {
                            enable = false,
                        },
                    },
                },
            })
            -- Mapping <leader>e pour toggle l’explorer
            vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer Files" })
        end,
    },
}
