return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require('ayu').setup({
        overrides = {}, 
      })
      vim.cmd("colorscheme ayu-dark")
    end,
  },

 
}
