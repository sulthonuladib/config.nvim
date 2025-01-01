local js_by_ft = function()
  local prettier_files = {
    ".prettierrc.js",
    ".prettierrc.json",
    ".prettierrc.yaml",
    ".prettierrc.yml",
    ".prettierrc",
    ".prettierrc.toml",
    "eslint.config.js",
  }
  local biome_files = { "biome.json", "biome.jsonc" }

  local filetype = {}

  for _, file in ipairs(prettier_files) do
    if vim.fn.glob(file) ~= "" then
      table.insert(filetype, "prettierd")
    end
  end

  for _, file in ipairs(biome_files) do
    if vim.fn.glob(file) ~= "" then
      table.insert(filetype, "biome")
    end
  end

  return { "prettierd" }
end

return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- typescript = { "biome", "prettierd" },
        -- javascript = { "biome", "prettierd" },
        go = { "gofmt" },
        javascript = js_by_ft(),
        typescript = js_by_ft(),
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
