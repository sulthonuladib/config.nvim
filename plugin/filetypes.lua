vim.filetype.add({
  extension = {
    templ = "templ",
  },
  pattern = {
    [".*%.php%.blade"] = "blade",
  },
})
