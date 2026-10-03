return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt" },
                javascript = { "oxfmt" },

                typescript = { "oxfmt" },
                templ = { "templ" },
            },
            formatters = {
                -- conform already ships this via util.from_node_modules("oxfmt");
                -- this just makes the node_modules-first intent explicit.
                oxfmt = {
                    command = function(_, ctx)
                        return require("sulthonuladib.helpers").resolve_node_bin(
                            "oxfmt",
                            ctx.dirname
                        )
                    end,
                },
            },
        })

        vim.keymap.set("n", "<leader>f", function()
            conform.format({
                bufnr = vim.api.nvim_get_current_buf(),
                lsp_fallback = true,
                quiet = true,
            })
        end, {
            desc = "Format buffer",
        })
    end,
}
