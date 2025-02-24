return {
  -- "zbirenbaum/copilot.lua",
  -- cmd = "Copilot",
  -- event = "InsertEnter",
  -- config = function()
  --   require("copilot").setup({
  --     panel = {
  --       enabled = false,
  --       -- auto_refresh = false,
  --       -- keymap = {
  --       --   jump_prev = "[[",
  --       --   jump_next = "]]",
  --       --   accept = "<CR>",
  --       --   refresh = "gr",
  --       --   open = "<M-CR>",
  --       -- },
  --       -- layout = {
  --       --   position = "bottom", -- | top | left | right | horizontal | vertical
  --       --   ratio = 0.4,
  --       -- },
  --     },
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --       hide_during_completion = true,
  --       debounce = 10,
  --       keymap = {
  --         accept = "<Tab>",
  --         accept_word = true,
  --         accept_line = false,
  --         next = "<M-]>",
  --         prev = "<M-[>",
  --         dismiss = "<C-]>",
  --       },
  --     },
  --     filetypes = {
  --       -- yaml = false,
  --       -- markdown = false,
  --       help = false,
  --       gitcommit = false,
  --       gitrebase = false,
  --       hgcommit = false,
  --       svn = false,
  --       cvs = false,
  --       ["."] = false,
  --     },
  --     copilot_node_command = "/home/sulthonuladib/.nvm/versions/node/v22.12.0/bin/node", -- Node.js version must be > 18.x
  --     server_opts_overrides = {},
  --   })
  -- end,

  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<M-]>",
        accept_word = "<C-l>",
      },
      ignore_filetypes = { cpp = true }, -- or { "cpp", }
      -- color = {
      --   -- suggestion_color = "#ffffff",
      --   cterm = 244,
      -- },
      log_level = "off", -- set to "off" to disable logging completely
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = false, -- disables built in keymaps for more manual control
      condition = function()
        return false
      end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
    })
  end,
}
