return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		-- { "folke/neodev.nvim", opts = {} },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>fs", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>vd", vim.diagnostic.open_float, "Open [D]iagnostics")
				map("<leader>]d", vim.diagnostic.get_next, "Next [D]iagnostic")
				map("<leader>[d", vim.diagnostic.get_prev, "Previous [D]iagnostic")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				-- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				map("<leader>ih", function()
					local enabled = vim.lsp.inlay_hint.is_enabled({})
					vim.lsp.inlay_hint.enable(not enabled)
				end, "[I]nlay [H]int")

				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			gopls = {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},
			-- pyright = {},
			rust_analyzer = {},
			-- LANG: Typescript and Javascript with tsserver
			-- tsserver = {
			-- 	settings = {
			-- 		javascript = {
			-- 			inlayHints = {
			-- 				includeInlayEnumMemberValueHints = true,
			-- 				includeInlayFunctionLikeReturnTypeHints = true,
			-- 				includeInlayFunctionParameterTypeHints = true,
			-- 				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
			-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			-- 				includeInlayPropertyDeclarationTypeHints = true,
			-- 				includeInlayVariableTypeHints = false,
			-- 			},
			-- 		},
			--
			-- 		typescript = {
			-- 			inlayHints = {
			-- 				includeInlayEnumMemberValueHints = true,
			-- 				includeInlayFunctionLikeReturnTypeHints = true,
			-- 				includeInlayFunctionParameterTypeHints = true,
			-- 				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
			-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			-- 				includeInlayPropertyDeclarationTypeHints = true,
			-- 				includeInlayVariableTypeHints = false,
			-- 			},
			-- 		},
			-- 	},
			-- },
			bufls = {
				settings = {
					bufls = {
						diagnostics = {},
					},
				},
			},

			-- LANG: Lua with lua_ls
			-- lua_ls = {
			-- 	settings = {
			-- 		Lua = {
			--                      runtime = {
			--                          version = "LuaJIT",
			--                          path = vim.split(package.path, ";"),
			--                      },
			-- 			completion = {
			-- 				callSnippet = "Replace",
			-- 			},
			-- 			diagnostics = {
			-- 				globals = { "vim" },
			-- 			},
			--                      workspace = {
			--                          library = {
			--                              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
			--                              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
			--                          },
			--                      },
			-- 		},
			-- 	},
			-- },
		}

		require("mason").setup()

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"prettierd",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		-- lsp helper styling
		local border = "rounded"
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
	end,
}
