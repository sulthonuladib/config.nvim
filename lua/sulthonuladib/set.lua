local opt = vim.opt

opt.nu = true
opt.relativenumber = true
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1 -- Height of the command bar

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartcase = true
opt.breakindent = true
opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

-- opt.list = true
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.scrolloff = 10
opt.signcolumn = "yes"
-- opt.isfname:append("@-@")

-- opt.updatetime = 50
-- opt.timeoutlen = 300
opt.smoothscroll = true
opt.cursorline = true

opt.colorcolumn = "80"
opt.inccommand = "split"
-- opt.termguicolors = false

-- nvim title
vim.o.title = true
opt.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " - nvim"

-- disable vim mark
vim.opt.viminfo:remove("m")

-- lazy nvim-tree integration, disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
