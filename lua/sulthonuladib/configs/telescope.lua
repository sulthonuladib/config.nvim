local data = assert(vim.fn.stdpath("data")) --[[@as string]]

local telescope = require("telescope")
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local previewers = require("telescope.previewers")

local data = assert(vim.fn.stdpath("data")) --[[@as string]]

telescope.setup({
  pickers = {
    find_files = {
      theme = "ivy",
    },
    live_grep = {
      theme = "ivy",
    },
    grep_string = {
      theme = "ivy",
    },
    git_files = {
      theme = "ivy",
    },
    help_tags = {
      theme = "ivy",
    },
  },
  defaults = {
    file_ignore_patterns = {
      "%_templ.go",
      "bun.lock",
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
      },
    },
  },
  extensions = {
    wrap_results = {},
    frecency = {},
    history = {
      path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
      limit = 100,
    },
    fzf = {},
    ["ui-select"] = {
      require("telescope.themes").get_ivy({}),
    },
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "frecency")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {
  desc = "Find files",
})
vim.keymap.set("n", "<leader>en", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, {
  desc = "Find Neovim config files",
})

vim.keymap.set("n", "<C-p>", builtin.git_files, {}, {
  desc = "Find git files",
})
vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
vim.keymap.set("n", "<leader>pws", function()
  local word = vim.fn.expand("<cword>")
  builtin.grep_string({ search = word })
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>pWs", function()
  local word = vim.fn.expand("<cWORD>f")
  builtin.grep_string({ search = word })
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Find help tags" })
