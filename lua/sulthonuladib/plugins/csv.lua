return {
  "hat0uma/csvview.nvim",
  config = function()
    require("csvview").setup({
      parser = {
        --- The number of lines that the asynchronous parser processes per cycle.
        --- This setting is used to prevent monopolization of the main thread when displaying large files.
        --- If the UI freezes, try reducing this value.
        async_chunksize = 50,
      },
      -- view = {
      -- 	--- minimum width of a column
      -- 	min_column_width = 5,
      -- 	--- spacing between columns
      -- 	spacing = 2,
      -- },
    })
  end,
}
