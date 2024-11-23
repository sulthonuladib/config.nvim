return {
  {
    -- Automatically set the indent of a file
    -- "tpope/vim-sleuth",
  },
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
}
