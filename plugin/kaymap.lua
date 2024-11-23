local set = vim.keymap.set
local fn = require('sulthonuladib.f').fn

set("n", "<M-h>", "<c-w>5<")
set("n", "<M-l>", "<c-w>5>")
set("n", "<M-j>", "<C-W>+")
set("n", "<M-k>", "<C-W>-")

-- Moving between tab
set("n", "<space>tn", vim.cmd.tabnext, { desc = "Move to next tab" })
set("n", "<space>tp", vim.cmd.tabprevious, { desc = "Move to previous tab" })

-- diagnostic
set("n", "]d", fn(vim.diagnostic.jump, { count = 1, float = true }))
set("n", "[d", fn(vim.diagnostic.jump, { count = -1, float = true }))
