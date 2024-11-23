vim.g.copilot_node_command = "/home/sulthonuladib/.nvm/versions/node/v20.15.1/bin/node"
-- vim.g.node_host_prog = "/home/sulthonuladib/.nvm/versions/node/v20.15.1/lib/node_modules/neovim/bin/cli.js"
--
require("sulthonuladib")
-- vim.notify = require("notify")
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

-- vim.cmd.colorscheme("tokyonight-night")
-- vim.cmd.colorscheme("catppuccin")
-- vim.cmd.colorscheme("obscure")
-- vim.cmd.colorscheme("gruvbuddy")
vim.cmd.colorscheme("base16-tomorrow-night-eighties")
-- vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000", border = "orange" }
