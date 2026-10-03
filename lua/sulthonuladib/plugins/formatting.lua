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
