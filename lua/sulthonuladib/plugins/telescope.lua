return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-smart-history.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- "nvim-telescope/telescope-project.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_layout = require("telescope.actions.layout")

    telescope.setup({
      defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        multi_icon = "<>",
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.80,
          height = 0.90,
          -- preview_cutoff = 120,
          prompt_position = "bottom",
          horizontal = {
            preview_width = function(_, cols, _)
              if cols > 200 then
                return math.floor(cols * 0.5)
              else
                return math.floor(cols * 0.5)
              end
            end,
          },

          vertical = {
            width = 0.9,
            height = 0.95,
            preview_height = 0.5,
          },

          flex = {
            horizontal = {
              preview_width = 0.8,
            },
          },
        },

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

            -- ["<C-x>"] = action,
            -- ["<C-s>"] = actions.select_horizontal,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            -- ["<C-e>"] = actions.results_scrolling_down,
            -- ["<C-y>"] = actions.results_scrolling_up,
            -- ["<C-y>"] = set_prompt_to_entry_value,

            -- These are new :)
            ["<M-p>"] = action_layout.toggle_preview,
            ["<M-m>"] = action_layout.toggle_mirror,
            -- ["<M-p>"] = action_layout.toggle_prompt_position,

            -- ["<M-m>"] = actions.master_stack,

            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

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

        -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        -- file_ignore_patterns = nil,

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        history = {
          path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
          limit = 100,
        },
      },
      extensions = {
        fzf = {},
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
        -- project = {
        --   base_dirs = {
        --     "~/dev/src",
        --     { "~/dev/src2" },
        --     { "~/dev/src3", max_depth = 4 },
        --     { path = "~/dev/src4" },
        --     { path = "~/dev/src5", max_depth = 2 },
        --   },
        --   hidden_files = true, -- default: false
        --   theme = "dropdown",
        --   order_by = "asc",
        --   search_by = "title",
        --   sync_with_nvim_tree = true, -- default false
        --   -- default for on_project_selected = find project files
        --   on_project_selected = function(prompt_bufnr)
        --     -- Do anything you want in here. For example:
        --     project_actions.change_working_directory(prompt_bufnr, false)
        --     require("harpoon.ui").nav_file(1)
        --   end,
        -- },
      },
    })
    _ = require("telescope").load_extension("ui-select")
    _ = require("telescope").load_extension("smart_history")
    _ = require("telescope").load_extension("fzf")
    -- _ = require("telescope").extensions.project.project({})

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>pws", function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set("n", "<leader>pWs", function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end)
    -- vim.keymap.set("n", "<leader>pg", function()
    -- 	builtin.grep_string({ search = vim.fn.input("Grep > ") })
    -- end)
    vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    -- vim.keymap.set("n", ":", ":Telescope cmdline<CR>", { noremap = true, desc = "Cmdline" })

    -- lsp specific
  end,
}
