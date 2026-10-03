local M = {}

-- Walk up from `start` (a directory) and return the first executable
-- `node_modules/.bin/<name>`, or nil if none exists.
M.node_modules_bin = function(name, start)
    local dir = start or vim.fn.expand("%:p:h")
    if dir == "" then
        dir = vim.fn.getcwd()
    end
    for _, root in
        ipairs(
            vim.fs.find(
                "node_modules",
                { path = dir, upward = true, type = "directory" }
            )
        )
    do
        local bin = root .. "/.bin/" .. name
        if vim.fn.executable(bin) == 1 then
            return bin
        end
    end
end

-- Prefer the project-local binary, falling back to the one on $PATH.
M.resolve_node_bin = function(name, start)
    return M.node_modules_bin(name, start) or name
end

-- Deno-aware TypeScript project root detection (mirrors lspconfig's
-- tsc/vtsls). Returns the root directory, or nil for Deno files.
M.ts_project_root = function(bufnr)
    local root_markers = {
        "package-lock.json",
        "yarn.lock",
        "pnpm-lock.yaml",
        "bun.lockb",
        "bun.lock",
    }
    root_markers = vim.fn.has("nvim-0.11.3") == 1
            and { root_markers, { ".git" } }
        or vim.list_extend(root_markers, { ".git" })

    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
        return
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
        return
    end
    return project_root or vim.fn.getcwd()
end

-- True if `bin` is a tsc that supports the built-in `--lsp` (TypeScript 7+).
M.tsc_supports_lsp = function(bin)
    if not bin or vim.fn.executable(bin) ~= 1 then
        return false
    end
    local out = vim.system({ bin, "--version" }, { text = true }):wait()
    if out.code ~= 0 then
        return false
    end
    local version = vim.version.parse(out.stdout or "")
    return version ~= nil and version.major >= 7
end

M.imap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { desc = "LSP: " .. desc })
end

M.nmap = function(keys, func, desc)
    vim.keymap.set("i", keys, func, { desc = "LSP: " .. desc })
end

return M
