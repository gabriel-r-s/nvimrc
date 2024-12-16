-- persisent undo
local UNDODIR = "/tmp/vi-undo"
vim.cmd("set undofile")
vim.cmd("set undodir=" .. UNDODIR)
