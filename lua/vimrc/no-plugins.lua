-- fallback in case there's no plugins

-- there's no undo tree visualizer
vim.keymap.set("", "<C-u>", "<Nop>")

-- no autopairs
vim.keymap.set("i", "<C-]>", "<Nop>")

-- substitute LSP stuff
vim.keymap.set("", "H", "K")
vim.keymap.set("", "J", "K")
vim.keymap.set("", "K", "K")
vim.keymap.set("", "L", "*")
-- no elp
vim.keymap.set("", "<F1>", "<Nop>")
-- there's no autocomplete, use keywork completion
vim.keymap.set("", "<C-Space>", "<Nop>")

-- no telescope
vim.keymap.set("", "<C-e>", ":!git ls-files 2>/dev/null || find . -type f -maxdepth 2<CR>:e ")
vim.keymap.set("", "<C-b>", ":ls<CR>:b ")
vim.keymap.set("", "<C-g>", "/") -- live grep?
vim.keymap.set("", "<C-f>", "/")
vim.keymap.set("", "<leader>r", ":registers<CR>:")
