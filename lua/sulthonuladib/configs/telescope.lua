local data = assert(vim.fn.stdpath("data")) --[[@as string]]

local telescope = require("telescope")
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local previewers = require("telescope.previewers")

telescope.setup({
  defaults = {
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    multi_icon = "<>",
    layout_strategy = "horizontal",
    -- layout_config = {
    --   width = 0.80,
    --   height = 0.90,
    --   -- preview_cutoff = 120,
    --   prompt_position = "bottom",
    --   horizontal = {
    --     preview_width = function(_, cols, _)
    --       if cols > 200 then
    --         return math.floor(cols * 0.5)
    --       else
    --         return math.floor(cols * 0.5)
    --       end
    --     end,
    --   },
    --
    --   vertical = {
    --     width = 0.9,
    --     height = 0.95,
    --     preview_height = 0.5,
    --   },
    --
    --   flex = {
    --     horizontal = {
    --       preview_width = 0.8,
    --     },
    --   },
    -- },

    selection_strategy = "reset",
    sorting_strategy = "descending",
    scroll_strategy = "cycle",
    color_devicons = true,

    mappings = {
      i = {
        ["<RightMouse>"] = actions.close,
        ["<LeftMouse>"] = actions.select_default,
        ["<ScrollWheelDown>"] = actions.move_selection_next,
        ["<ScrollWheelUp>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        -- These are new :)
        ["<M-p>"] = action_layout.toggle_preview,
        ["<M-m>"] = action_layout.toggle_mirror,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

        -- This is nicer when used with smart-history plugin.
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<c-g>s"] = actions.select_all,
        ["<c-g>a"] = actions.add_selection,
        ["<C-w>"] = function()
          vim.api.nvim_input("<c-s-w>")
        end,
      },

      n = {
        ["<C-e>"] = actions.results_scrolling_down,
        ["<C-y>"] = actions.results_scrolling_up,
      },
    },

    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    history = {
      limit = 100,
      path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
    },
  },
  extensions = {
    fzf = {},
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})
_ = require("telescope").load_extension("ui-select")
_ = require("telescope").load_extension("smart_history")
_ = require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {
  desc = "Find files",
})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
-- find vim config
vim.keymap.set("n", "<leader>ec", function()
  builtin.find_files({ cwd = "~/.config/nvim" })
end)
vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
vim.keymap.set("n", "<leader>pws", function()
  local word = vim.fn.expand("<cword>")
  builtin.grep_string({ search = word })
end)
vim.keymap.set("n", "<leader>pWs", function()
  local word = vim.fn.expand("<cWORD>")
  builtin.grep_string({ search = word })
end)
vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
