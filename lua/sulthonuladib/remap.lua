vim.g.mapleader = " "
local set = vim.keymap.set
-- set("n", "<leader>t", vim.cmd.NvimTreeToggle)

-- on visual mode, can move the highlighted up and down
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the highlighted text down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the highlighted text up" })

set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
set("n", "<C-d>", "<C-d>zz", { desc = "Move down half screen and center cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Move up half screen and center cursor" })
set("n", "n", "nzzzv", { desc = "Move to next search result and center cursor" })
set("n", "N", "Nzzzv", { desc = "Move to previous search result and center cursor" })

-- greatest remap ever, keeping the word after paste of highlighted.
set("x", "<leader>p", [["_dP]], { desc = "Paste and keep word" })

-- next greatest remap ever, thanks to  : asbjornHaland
set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
set("n", "<leader>Y", [["+Y]], { desc = "Copy to clipboard" })
set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Cut to clipboard" })

-- This is going to get me cancelled
set("i", "<C-c>", "<Esc>")

set("n", "Q", "<nop>")
set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- set("n", "<leader>f", vim.lsp.buf.format)

set("n", "<C-k>", "<cmd>cnext<CR>zz")
set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- mark any word and press <leader>s to search and replace
set(
  "n", -- normal mode
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
)
