return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    dependencies = {
      "EmranMR/tree-sitter-blade",
    },
    config = function()
      require("sulthonuladib.configs.treesitter").setup()
    end,
  },
}
