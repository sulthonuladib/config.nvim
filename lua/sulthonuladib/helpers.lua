local M = {}

M.imap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = "LSP: " .. desc })
end

M.nmap = function(keys, func, desc)
  vim.keymap.set("i", keys, func, { desc = "LSP: " .. desc })
end

return M
