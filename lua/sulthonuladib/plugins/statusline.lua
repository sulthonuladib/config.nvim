return {
  {
    "echasnovski/mini.nvim",
    enabled = false,
    config = function()
      require("mini.statusline").setup({ use_icons = true })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    -- enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },

    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "nightfly",
          -- theme = "palenight",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          -- lualine_b = {},
          lualine_c = { { "filename", path = 0 } },
          lualine_x = { "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 0 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}
