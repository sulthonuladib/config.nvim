vim.o.tabline = "%!v:lua.Tabline()"

function _G.Tabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)

    local relname = vim.fn.fnamemodify(bufname, ":.")
    if relname == "" then
      relname = "[No Name]"
    end

    -- Highlight current tab
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#" .. " " .. relname .. " "
    else
      s = s .. "%#TabLine#" .. " " .. relname .. " "
    end
  end
  s = s .. "%#TabLineFill#"
  return s
end
