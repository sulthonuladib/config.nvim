local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

  require("nvim-treesitter").setup({
    ensure_install = { "core", "stable" },
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "ruby" },
    },
    additional_vim_regex_highlighting = { "ruby" },
  })

  local syntax_on = {
    elixir = true,
    php = true,
  }

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
      if not ok or not parser then
        return
      end
      pcall(vim.treesitter.start)

      local ft = vim.bo[bufnr].filetype
      if syntax_on[ft] then
        vim.bo[bufnr].syntax = "on"
      end
    end,
  })

  -- external parser that not listed on treesitter
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "TSUpdate",
    callback = function()
      local parser_config = require("nvim-treesitter.parsers")

      parser_config.blade = {
        tier = 0,
        ---@diagnostic disable-next-line: missing-fields
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }
    end,
  })
end

M.setup()

return M
