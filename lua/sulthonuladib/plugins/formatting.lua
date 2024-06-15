return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require('conform')
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                typescript = { "prettierd", "prettier" },
                javascript = { "prettierd", "prettier" },
                go = { "gofmt" },
            }
        })

        vim.keymap.set("n", "<leader>f", function()
            conform.format({
                bufnr = vim.api.nvim_get_current_buf(),
                lsp_fallback = true,
                quiet = true,
            })
        end)
    end
}

