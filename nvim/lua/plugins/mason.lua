return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = { "lua_ls" },
            automatic_installation = true,
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end,
    },
}
