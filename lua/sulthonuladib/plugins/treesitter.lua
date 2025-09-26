return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("sulthonuladib.configs.treesitter").setup()
      require('treesitter-context').setup();
    end,
  },
}
