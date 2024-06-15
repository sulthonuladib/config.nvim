local opt = vim.opt

opt.guicursor = ""

opt.nu = true
opt.relativenumber = true
opt.showmode = false
opt.showcmd = true
-- opt.cmdheight = 1 -- Height of the command bar

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartcase = true

opt.autoindent = true
opt.cindent = true
opt.breakindent = true
opt.linebreak = true
opt.modelines = 1

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.list = true
-- opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', eol = '↲' }

-- opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50
opt.smoothscroll = true
opt.cursorline = true

opt.colorcolumn = "80"
opt.inccommand = "split"

-- nvim title
vim.o.title = true
-- vim.o.titlestring = "{'%:p:h'}"
vim.opt.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " - nvim"

-- disable vim mark
vim.opt.viminfo:remove('m')

-- lazy nvim-tree integration, disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
    vim.api.nvim_create_autocmd(event, {
        group = group,
        pattern = pattern,
        callback = function()
            vim.opt_local.cursorline = value
        end,
    })
end

set_cursorline("WinLeave", false)
set_cursorline("FileType", false, "TelescopePrompt")
set_cursorline("WinEnter", true)
