require "nvchad.options"

-- add yours here!

-- Treat .tpl files as JSON
vim.filetype.add({
  extension = {
    tpl = "json",
  },
})

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
