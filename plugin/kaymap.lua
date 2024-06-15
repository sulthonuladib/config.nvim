local set = vim.keymap.set

set("n", "<M-h>", "<c-w>5<")
set("n", "<M-l>", "<c-w>5>")
set("n", "<M-j>", "<C-W>+")
set("n", "<M-k>", "<C-W>-")

-- Moving between tab
set("n", "<leader>tn", vim.cmd.tabnext, { desc = "Move to next tab" })
set("n", "<leader>tp", vim.cmd.tabprevious, { desc = "Move to previous tab" })
