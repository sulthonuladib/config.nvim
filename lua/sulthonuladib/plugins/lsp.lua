local function typescript_organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.Client:exec_cmd("_typescript.organizeImports")
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { "j-hui/fidget.nvim", opts = {} },
    -- { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        local imap = function(keys, func, desc)
          vim.keymap.set("i", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
        imap("<C-h>", function()
          vim.lsp.buf.signature_help({
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
          })
        end, "Signature [H]elp")
        map("<leader>gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
        map("<leader>fs", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>vd", vim.diagnostic.open_float, "Open [D]iagnostics")

        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("<leader>vca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("<leader>ih", function()
          local enabled = vim.lsp.inlay_hint.is_enabled({})
          vim.lsp.inlay_hint.enable(not enabled)
        end, "[I]nlay [H]int")

        -- map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("K", function()
          vim.lsp.buf.hover({
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
          })
        end, "Hover Documentation")

        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      end,
    })

    local capabilities = nil
    if pcall(require, "cmp_nvim_lsp") then
      capabilities = require("cmp_nvim_lsp").default_capabilities()
    end

    local servers = {
      -- gopls = {
      --   settings = {
      --     gopls = {
      --       analyses = {
      --         unusedparams = true,
      --       },
      --       staticcheck = true,
      --       hints = {
      --         assignVariableTypes = true,
      --         compositeLiteralFields = true,
      --         compositeLiteralTypes = true,
      --         constantValues = true,
      --         functionTypeParameters = true,
      --         parameterNames = true,
      --         rangeVariableTypes = true,
      --       },
      --     },
      --   },
      -- },

      rust_analyzer = {},
      -- phpactor = {
      --   filetypes = { "php", "blade" },
      -- },
      intelephense = {
        filetypes = { "php", "blade" },
      },

      -- LANG: Typescript and Javascript with tsserver
      ts_ls = {
        settings = {
          server_capabilities = {
            -- documentFormattingProvider = false,
            -- are there a capabilities for organizing import
          },
        },
        commands = {
          OrganizeImports = {
            typescript_organize_imports,
            description = "Organize Imports",
          },
        },
      },
      docker_compose_language_service = {
        filetypes = { "yaml.docker-compose", "yaml" },
      },
      -- html = {
      --   filetypes = { "html", "templ" },
      -- },
      -- htmx = {
      --   filetypes = { "html", "templ" },
      -- },
      tailwindcss = {
        filetypes = { "html", "templ", "astro", "typescript", "javascript", "react", "blade", "typescriptreact" },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              templ = "html",
            },
          },
        },
      },
      templ = {
        filetypes = { "templ" },
        root_dir = require("lspconfig.util").root_pattern("go.mod", ".git"),
        settings = {},
      },
    }

    require("mason").setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      -- "stylua", -- Used to format Lua code
      -- "prettierd",
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = ensure_installed,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

          require("lspconfig")[server_name].setup(server)
        end,
      },
    })

    -- NOTE: deprecated
    -- local border = "rounded"
    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    --   border = border,
    -- })
    -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    --   border = border,
    -- })
  end,
}
