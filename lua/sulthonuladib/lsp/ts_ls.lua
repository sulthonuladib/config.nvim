return {
  root_dir = require("lspconfig.util").root_pattern({
    "package.json",
    "tsconfig.json",
  }),
  single_file_support = false,
  settings = {},
  -- settings = {
  --   server_capabilities = {
  --     documentFormattingProvider = false,
  --   },
  --   javascript = {
  --     inlayHints = {
  --       includeInlayEnumMemberValueHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayVariableTypeHints = false,
  --     },
  --   },
  --   typescript = {
  --     inlayHints = {
  --       includeInlayEnumMemberValueHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayVariableTypeHints = false,
  --     },
  --   },
  -- },
}
