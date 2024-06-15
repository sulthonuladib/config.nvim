require('sulthonuladib.set')
require('sulthonuladib.remap')
require('sulthonuladib.plugin')

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local CommonGroup = augroup('CommonGroup', {})
local YankingGroup = augroup('HighlightYank', {})

autocmd({ "BufWritePre" }, {
    group = CommonGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- autocmd('LspAttach', {
--     group = CommonGroup,
--     callback = function(e)
--         local builtin = require('telescope.builtin')
--         local opts = { buffer = e.buf }
--
--         vim.keymap.set("n", "gd", function() builtin.lsp_definitions() end, opts)
--         vim.keymap.set("n", "<leader>vrr", function() builtin.lsp_references() end, opts)
--
--         vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
--         vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
--
--         vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
--         vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
--         vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
--         vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
--         vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
--         vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
--         vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
--     end
-- })

autocmd('TextYankPost', {
    group = YankingGroup,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})
