require("sulthonuladib.set")
require("sulthonuladib.remap")
require("sulthonuladib.plugin")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local CommonGroup = augroup("CommonGroup", {})
local YankGroup = augroup("HighlightYank", {})

autocmd({ "BufWritePre" }, {
  group = CommonGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

autocmd("TextYankPost", {
  group = YankGroup,
  pattern = "*",
  callback = function()
    vim.hl.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})
