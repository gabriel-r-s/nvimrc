vim.keymap.set("", ";", ":")
vim.keymap.set("", ":", ":<C-f>i")

vim.keymap.set("", "ç", ";")
vim.keymap.set("", "Ç", ",")

vim.keymap.set("", ",", "`")

vim.keymap.set("i", "<C-l>", "<right>")

vim.keymap.set("v", "<C-c>", "\"+y")

-- xterm + vifm workaround
vim.keymap.set("", "<C-^>", "<C-i>")

-- find on visible screen
vim.keymap.set("n", "s", ":set cul | set cuc<CR>mYHVL<Esc>`Y/\\%V")
vim.keymap.set("n", "S", ":set cul | set cuc<CR>mYHVL<Esc>`Y?\\%V")

-- disable
vim.keymap.set("", "H", "<Nop>")
vim.keymap.set("", "J", "<Nop>")
vim.keymap.set("", "K", "<Nop>")
vim.keymap.set("", "L", "<Nop>")
vim.keymap.set("n", "<CR>", "<Nop>") -- dont repeat last command
vim.keymap.set("i", "<C-Space>", "<Nop>")

-- real/displayed lines + soft/hard BOL
vim.keymap.set("", "0", "g^")
vim.keymap.set("", "g0", "0")
vim.keymap.set("n", "I", "g^i")
vim.keymap.set("n", "gI", "I")
vim.keymap.set("", "$", "g$")
vim.keymap.set("", "g$", "$")
vim.keymap.set("n", "A", "g$a")
vim.keymap.set("n", "gA", "A")
vim.keymap.set("", "j", function() return vim.v.count == 0 and "gj" or "j" end, { expr = true })
vim.keymap.set("", "k", function() return vim.v.count == 0 and "gk" or "k" end, { expr = true })
vim.keymap.set("", "gj", function() return vim.v.count == 0 and "j" or "gj" end, { expr = true })
vim.keymap.set("", "gk", function() return vim.v.count == 0 and "k" or "gk" end, { expr = true })

-- the actual good stuff
vim.keymap.set("", "<C-j>", "<C-d>")
vim.keymap.set("", "<C-k>", "<C-u>")
vim.keymap.set("", "<C-h>", "5<C-e>")
vim.keymap.set("", "<C-l>", "5<C-y>")
vim.keymap.set("", "<C-n>", "<C-e>")
vim.keymap.set("", "<C-p>", "<C-y>")

vim.keymap.set("", "[[", ":bprev<CR>", { remap = true })
vim.keymap.set("", "]]", ":bnext<CR>", { remap = true })

-- indent with just one >
vim.keymap.set("n", "<", "<<")
vim.keymap.set("n", ">", ">>")
-- keep visual mode after indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- folding
vim.keymap.set("v", "<S-Tab>", "zf")
vim.keymap.set("n", "<S-Tab>", "za")

-- centering and highlighting
vim.keymap.set("n", "<CR>", "zz10<C-e>")
vim.keymap.set("n", "<Esc>", ":noh | set nocul | set nocuc<CR>", { silent = true })
vim.keymap.set("n", "n", "n:set cul | set cuc<CR>", { silent = true })
vim.keymap.set("n", "N", "N:set cul | set cuc<CR>", { silent = true })
vim.keymap.set("n", "n", "n:set cul | set cuc<CR>", { silent = true })
vim.keymap.set("n", "N", "N:set cul | set cuc<CR>", { silent = true })
-- vim.keymap.set("n", "<C-o>", "<C-o>zz")
-- vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "G", "Gzz")
-- vim.keymap.set("n", "gg", "ggzz:set cursorline<CR>", { silent = true })
vim.keymap.set("n", "gg", "gg:set cursorline<CR>", { silent = true })

-- <leader> bindings
vim.g.mapleader = " "

-- misc <leader> bindings
vim.keymap.set("n", "<leader>p", "`[v`]")                        -- select last pasted (visual)
vim.keymap.set("n", "<leader>v", "gv")                           -- repeat selection
vim.keymap.set("n", "<leader><leader>", "gcc", { remap = true }) -- toggle comment
vim.keymap.set("v", "<leader><leader>", "gc", { remap = true })  -- toggle comment (visual)

vim.keymap.set("", "<leader>b", ":ls<CR>:b ")
vim.keymap.set("", "<leader>e", ":!sh -c 'git ls-files 2>/dev/null || find .'<CR>:e ")
vim.keymap.set("", "<leader>w", ":wa<CR>")
vim.keymap.set("", "<C-m>", "<C-w>n:exec 'terminal make' | startinsert<CR>", { silent = true })

local function focus_open_or_create_terminal()
    -- there isn't a terminal buffer, create one
    local bufnr = vim.fn.bufnr("0xTTTTerm")
    if bufnr == -1 then
        vim.cmd("exec 'terminal' | file 0xTTTTerm | startinsert")
        return
    end
    -- terminal is not currently visible
    local wins = vim.fn.win_findbuf(bufnr)
    if #wins == 0 then
        if vim.fn.winwidth(0) > 100 then
            vim.cmd("exec 'buffer " .. bufnr .. "' | startinsert")
            return
        else
            vim.cmd("exec 'buffer " .. bufnr .. "' | startinsert")
        end
    end
    -- focus the terminal window
    vim.fn.win_gotoid(wins[1])
    vim.cmd("startinsert")
    -- TODO: when session is saved, terminal buffers revert to text buffers
    -- TODO: detect if switched buffer is actually terminal, buftype(..)
    -- TODO: and if not call :terminal
end
vim.keymap.set("", "<C-t>", focus_open_or_create_terminal)
vim.keymap.set("t", "<C-o>", "<C-\\><C-n><C-o>")
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>")
vim.keymap.set("t", "<S-space>", "<Nop>")

local function smart_split()
    if vim.fn.winwidth(0) > 100 then
        return "<C-w>v<C-w>l<CR>"
    else
        return "<C-w>n"
    end
end
vim.keymap.set("", "<C-s>", smart_split, { expr = true })
vim.keymap.set("n", "<Tab>", "<C-w><C-w>")
vim.keymap.set("", "<C-q>", ":q<CR>")
vim.keymap.set("", "<C-,>,", ":bp<CR>")
vim.keymap.set("", "<C-.>.", ":bn<CR>")
