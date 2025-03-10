-- set window title
vim.opt.titlestring = " nvim %f"
vim.opt.title = true

-- style
vim.opt.termguicolors = true
vim.cmd.colorscheme("retrobox")
vim.opt.signcolumn = "no"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.linebreak = true -- wrap on words

-- default indent for txt/md
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- fold
vim.opt.foldmethod = "manual"

-- misc config
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true -- new horizontal split goes below
vim.opt.autoread = true   -- auto update files for git
vim.opt.smoothscroll = true


-- auto :only on focused vim window when splitting desktop window
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    callback = function()
        if vim.o.columns < 120 then
            vim.cmd("only")
        end
    end
})

vim.cmd("let g:_prev_search_pattern = @/")
-- no highlight on insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        vim.cmd("set nocursorcolumn")
        vim.cmd("set nocursorline")
        -- save prev search
        vim.cmd("let g:_prev_search_pattern = @/")
        vim.cmd("let @/ = ''")
    end
})

-- recover search pattern
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        vim.cmd("let @/ = g:_prev_search_pattern")
    end
})
