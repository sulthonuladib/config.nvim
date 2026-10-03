-- local function typescript_organize_imports()
--   local params = {
--     command = "_typescript.organizeImports",
--     arguments = { vim.api.nvim_buf_get_name(0) },
--     title = "",
--   }
--   vim.lsp.Client:exec_cmd("_typescript.organizeImports")
-- end

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
                    vim.keymap.set(
                        "n",
                        keys,
                        func,
                        { buffer = event.buf, desc = "LSP: " .. desc }
                    )
                end

                local imap = function(keys, func, desc)
                    vim.keymap.set(
                        "i",
                        keys,
                        func,
                        { buffer = event.buf, desc = "LSP: " .. desc }
                    )
                end

                vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
                imap("<C-h>", function()
                    vim.lsp.buf.signature_help({
                        border = {
                            "┌",
                            "─",
                            "┐",
                            "│",
                            "┘",
                            "─",
                            "└",
                            "│",
                        },
                    })
                end, "Signature [H]elp")
                map(
                    "<leader>gd",
                    require("telescope.builtin").lsp_definitions,
                    "[G]oto [D]efinition"
                )
                map(
                    "gd",
                    require("telescope.builtin").lsp_definitions,
                    "[G]oto [D]efinition"
                )
                map(
                    "<leader>gr",
                    require("telescope.builtin").lsp_references,
                    "[G]oto [R]eferences"
                )
                map(
                    "gI",
                    require("telescope.builtin").lsp_implementations,
                    "[G]oto [I]mplementation"
                )
                map(
                    "<leader>D",
                    require("telescope.builtin").lsp_type_definitions,
                    "Type [D]efinition"
                )
                map(
                    "<leader>fs",
                    require("telescope.builtin").lsp_document_symbols,
                    "[D]ocument [S]ymbols"
                )
                map(
                    "<leader>ws",
                    require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    "[W]orkspace [S]ymbols"
                )
                map(
                    "<leader>vd",
                    vim.diagnostic.open_float,
                    "Open [D]iagnostics"
                )

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
                        border = {
                            "┌",
                            "─",
                            "┐",
                            "│",
                            "┘",
                            "─",
                            "└",
                            "│",
                        },
                    })
                end, "Hover Documentation")

                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
            end,
        })

        local capabilities = nil
        if pcall(require, "cmp_nvim_lsp") then
            capabilities = require("cmp_nvim_lsp").default_capabilities()
        end

        local helpers = require("sulthonuladib.helpers")

        -- Whether the project at `root` ships a TypeScript 7+ `tsc` (which has
        -- the built-in `--lsp`). Cached per root.
        local native_tsc_cache = {}
        local function has_native_tsc(root)
            if native_tsc_cache[root] == nil then
                native_tsc_cache[root] = helpers.tsc_supports_lsp(
                    helpers.node_modules_bin("tsc", root)
                )
            end
            return native_tsc_cache[root]
        end

        local servers = {
            -- TypeScript 7+: the native compiler ships the LSP in `tsc`.
            tsc = {
                root_dir = function(bufnr, on_dir)
                    local root = helpers.ts_project_root(bufnr)
                    if root and has_native_tsc(root) then
                        on_dir(root)
                    end
                end,
                cmd = function(dispatchers, config)
                    local tsc = helpers.node_modules_bin(
                        "tsc",
                        (config or {}).root_dir
                    )
                    return vim.lsp.rpc.start(
                        { tsc, "--lsp", "--stdio" },
                        dispatchers
                    )
                end,
                settings = {
                    ["js/ts"] = {
                        server_capabilities = {
                            documentFormattingProvider = false,
                        },
                    },
                },
            },
            -- TypeScript < 7: fall back to `vtsls`, which auto-detects the
            -- workspace TypeScript version.
            vtsls = {
                root_dir = function(bufnr, on_dir)
                    local root = helpers.ts_project_root(bufnr)
                    if root and not has_native_tsc(root) then
                        on_dir(root)
                    end
                end,
                cmd = function(dispatchers, config)
                    local vtsls = helpers.node_modules_bin(
                            "vtsls",
                            (config or {}).root_dir
                        )
                        or vim.fn.exepath("vtsls")
                    if vtsls == "" then
                        vtsls = "vtsls"
                    end
                    return vim.lsp.rpc.start({ vtsls, "--stdio" }, dispatchers)
                end,
                init_options = { hostInfo = "neovim" },
            },
            oxlint = {
                -- Prefer node_modules/.bin/oxlint, walking up parent dirs so hoisted
                -- monorepo installs are found too; fall back to `oxlint` on $PATH.
                cmd = function(dispatchers, config)
                    local cmd =
                        require("sulthonuladib.helpers").resolve_node_bin(
                            "oxlint",
                            (config or {}).root_dir
                        )
                    return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
                end,
            },

            rust_analyzer = {},
            -- LANG: Typescript and Javascript with tsserver
            -- ts_ls = {
            --   settings = {
            --     server_capabilities = {
            --       -- documentFormattingProvider = false,
            --       -- are there a capabilities for organizing import
            --     },
            --   },
            --   commands = {
            --     OrganizeImports = {
            --       typescript_organize_imports,
            --       description = "Organize Imports",
            --     },
            --   },
            -- },
            -- docker_compose_language_service = {
            --   filetypes = { "yaml.docker-compose", "yaml" },
            -- },
            -- html = {
            --   filetypes = { "html", "templ" },
            -- },
            -- htmx = {
            --   filetypes = { "html", "templ" },
            -- },
            -- tailwindcss = {
            --   filetypes = { "html", "templ", "astro", "typescript", "javascript", "react", "typescriptreact" },
            --   settings = {
            --     tailwindCSS = {
            --       includeLanguages = {
            --         templ = "html",
            --       },
            --     },
            --   },
            -- },
            -- templ = {
            --   filetypes = { "templ" },
            --   root_dir = require("lspconfig.util").root_pattern("go.mod", ".git"),
            --   settings = {},
            -- },
        }

        require("mason").setup()
        -- vim.lsp.config("tsc", {
        --   cmd = { "tsc", "--lsp", "--stdio" },
        --   filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        --   settings = {},
        -- })
        -- vim.lsp.enable("tsc")

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            -- "stylua", -- Used to format Lua code
            -- "prettierd",
        })
        require("mason-tool-installer").setup({
            ensure_installed = ensure_installed,
        })

        -- mason-lspconfig v2 removed `handlers`. Apply each server's overrides
        -- through the modern `vim.lsp.config` API (it takes precedence over the
        -- `lsp/*.lua` defaults that Neovim auto-registers), then enable them.
        for name, server in pairs(servers) do
            if capabilities then
                server.capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    capabilities,
                    server.capabilities or {}
                )
            end
            vim.lsp.config(name, server)
        end

        require("mason-lspconfig").setup({
            automatic_installation = true,
            -- Keep auto-enabling the other installed servers, but never `ts_ls`
            -- (we use `tsc`/`vtsls` above).
            automatic_enable = { exclude = { "ts_ls" } },
            ensure_installed = ensure_installed,
        })

        vim.lsp.enable(vim.tbl_keys(servers))
    end,
}
