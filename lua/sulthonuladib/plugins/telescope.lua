return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-smart-history.nvim",

    "kkharji/sqlite.lua",
  },
  config = function ()
    require('sulthonuladib.configs.telescope')
  end
}
