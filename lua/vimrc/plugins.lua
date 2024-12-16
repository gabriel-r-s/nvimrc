-- lazy.!nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    -- usability
    { "windwp/nvim-autopairs",            event = "InsertEnter", },
    { "simnalamburt/vim-mundo",           dependencies = { "neovim/pynvim" } },
    { "nvim-telescope/telescope.nvim",    tag = "0.1.8",                     dependencies = { "nvim-lua/plenary.nvim" }, },
    -- theme and appearence
    { "stevearc/dressing.nvim",           config = true },
    { "nvim-lualine/lualine.nvim" },
    -- lsp plugins
    { "VonHeikemen/lsp-zero.nvim",        branch = "v4.x" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig",            tag = "v0.1.8" },
    { "lukas-reineke/lsp-format.nvim",    tag = "v2.7.1" },
    -- autocomplete
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-buffer" },
    -- { "hrsh7th/cmp-cmdline" },
    -- { "rafamadriz/friendly-snippets" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/nvim-cmp" },
    -- { "mawkler/refjump.nvim",                config = true },
    -- { "folke/trouble.nvim" },
})

local autopairs = require("nvim-autopairs")
autopairs.setup({
    -- ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=], -- default
    ignored_next_char = [=[[%w]]=],
    map_c_h = true,
    fast_wrap = {
        keys = "1234567890",
        map = "<C-ç>",
        manual_position = false, -- dont select left/right
    }
})

-- require("trouble").setup({
--     modes = {
--         preview_float = {
--             mode = "diagnostics",
--             preview = {
--                 type = "float",
--                 relative = "editor",
--                 border = "rounded",
--                 title = "Preview",
--                 title_pos = "center",
--                 position = { 0, -2 },
--                 size = { width = 0.3, height = 0.3 },
--                 zindex = 200,
--             },
--         },
--     },
-- })

local function location_slash()
    local line = vim.fn.line(".")
    local max_lines = vim.fn.line("$")
    local column = vim.fn.col(".")
    local max_columns = vim.fn.col("$")
    return string.format("%2d:%-2d %2d/%-2d", column, max_columns, line, max_lines)
end
local function pretty_cwd()
    local cwd = vim.fn.getcwd()
    local homedir = vim.fn.environ()["HOME"] or ""
    cwd = vim.fn.substitute(cwd, homedir, "~", "")
    local cwd_len = cwd:len()
    local max_cwd_len = 20
    if cwd_len > max_cwd_len then
        cwd = cwd:sub(cwd_len - max_cwd_len, cwd_len)
        cwd = "…" .. cwd
    end
    return cwd
end
require("lualine").setup({
    options = {
        icons_enabled = false,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", pretty_cwd },
        -- lualine_c = { "filename", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = {},
        lualine_z = { location_slash },
    },
    inactive_sections = {
        lualine_a = { "" },
        lualine_b = { "" },
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = {},
        lualine_z = { location_slash },
    },
})
vim.opt.showmode = false

vim.keymap.set("", "<C-u>", vim.cmd.MundoToggle)
vim.g.mundo_width = 35
vim.g.mundo_preview_statusline = 1
vim.g.mundo_preview_height = 15
vim.g.mundo_preview_bottom = 1

-- vim.keymap.set("", "<C-u>", vim.cmd.UndotreeToggle())
-- vim.g.undotree_DiffAutoOpen = 0
-- vim.g.undotree_SplitWidth = 40
-- vim.g.undotree_SetFocusWhenToggle = 1

local lsp_zero = require("lsp-zero")
local lsp_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        require("lsp-format").on_attach(client)
    end
    local opts = { buffer = bufnr }

    -- H (Esc?) popup signature and documentaion of current identifier
    vim.keymap.set("", "H", vim.lsp.buf.hover, opts) -- shows

    -- gH show float diagnostic
    vim.keymap.set("", "gH", function()
        vim.diagnostic.open_float(nil, { focus = false })
    end, opts)



    -- J jump to implementation
    vim.keymap.set("n", "J", function()
        vim.lsp.buf.implementation()
        vim.cmd("normal! zz")
    end, opts)

    -- go to type definition?
    vim.keymap.set("n", "gJ", vim.lsp.buf.type_definition, opts)

    -- popup signature (only functions?)
    vim.keymap.set("", "gL", vim.lsp.buf.signature_help, opts)

    -- jump to definition
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.definition()
        vim.cmd("normal! zz")
    end, opts)

    -- jump to declaration
    vim.keymap.set("n", "gK", function()
        vim.lsp.buf.declaration()
        vim.cmd("normal! zz")
    end, opts)

    -- L telescope references (declared forward)
    -- vim.keymap.set("n", "L", function()
    --     local t_opts = telescope_opts_contextual()
    --     require("telescope.builtin").lsp_references(t_opts)
    -- end)

    -- contextual code action (quick fix) TODO
    vim.keymap.set("n", "<F1>", function()
        local max_lines = vim.fn.line("$")
        local code_action_range = 5
        local cursor = vim.api.nvim_win_get_cursor(0)
        local above = { vim.fn.max({ 1, cursor[1] - code_action_range }), 0 }
        local below = { vim.fn.min({ max_lines, cursor[1] + code_action_range }), 0 }
        opts = vim.tbl_extend("force", opts, { range = { start = above, ["end"] = below } })
        vim.lsp.buf.code_action(opts)
        print(vim.inspect(opts):gsub("\n", ""))
    end)

    vim.keymap.set("v", "<F1>", vim.lsp.buf.code_action, opts)

    -- rename identifier
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

    -- manual trigger formatting, or only for selection
    vim.keymap.set("", "<F3>", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)

    -- split below a list of references (jump to ref?)
    vim.keymap.set("n", "<F4>", vim.lsp.buf.references, opts)
end

-- -- enable to auto show diagnostic
-- vim.o.updatetime = 250
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--     pattern = "*",
--     callback = function()
--         vim.diagnostic.open_float(nil, { focus = false })
--     end
-- })

lsp_zero.extend_lspconfig({
    lsp_zero = true,
    sign_text = true,
    lsp_attach = lsp_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

local lspconfig = require("lspconfig")
lspconfig.bashls.setup({})
lspconfig.clangd.setup({})
lspconfig.twiggy_language_server.setup({})
lspconfig.lua_ls.setup({
    -- cant find the right syntax or for this, just put in .luarc.json
    -- settings = { Lua = { disable = { "lowercase-global" } } },
    on_init = function(client)
        lsp_zero.nvim_lua_settings(client, {})
    end
})
lspconfig.pylsp.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.gdscript.setup({})

require("mason").setup({})
require("mason-lspconfig").setup({
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,
    },
})

local cmp = require("cmp")
-- local cmp_action = lsp_zero.cmp_action()
cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "luasnip" },
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-c>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    -- -- suggested mappings from lsp-zero tutorial
    --     ["<C-p>"] = cmp.mapping.select_prev_item({behavior="select"}),
    --     ["<C-n>"] = cmp.mapping.select_next_item({behavior="select"}),
    --     ["<C-y>"] = cmp.mapping.confirm({select=false}),
    --     ["<C-Space>"] = cmp.mapping.complete(),
    --     -- Navigate between snippet placeholder
    --     ["<C-f>"] = cmp_action.vim_snippet_jump_forward(),
    --     ["<C-b>"] = cmp_action.vim_snippet_jump_backward(),

    --     -- Scroll up and down in the completion documentation
    --     ["<C-k>"] = cmp.mapping.scroll_docs(-4),
    --     ["<C-j>"] = cmp.mapping.scroll_docs(4),
    snippet = {
        expand = function(args)
            -- vim.snippet.expand(args.body)
            require("luasnip").lsp_expand(args.body)
        end
    },
})

--
-- -- these break the default (good) nvim completion
-- -- Use buffer source for `/`, `?`, : (if you enabled `native_menu`, this won"t work anymore).
-- cmp.setup.cmdline({ "/", "?" }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = "buffer" }
--     }
-- })
-- cmp.setup.cmdline(":", {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = "path" }
--     }, {
--         { name = "cmdline" }
--     }),
--     matching = { disallow_symbol_nonprefix_matching = false }
-- })

cmp.event:on(
    "confirm_done",
    require("nvim-autopairs.completion.cmp").on_confirm_done()
)

require("telescope").setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim" -- add this value
        },
        mappings = {
            ["i"] = {
                ["<C-p>"] = require("telescope.actions").cycle_history_prev,
                ["<C-n>"] = require("telescope.actions").cycle_history_next,
            },
        },
    },
})
local git = require("vimrc.git")

local telescope = require("telescope.builtin")

local function telescope_opts_contextual()
    local telescope_horizontal_theme = {
        layout_strategy = "horizontal",
        layout_config = {
            preview_cutoff = 1,                                                -- dont hide preview on zoomed
            horizontal = { width = 9999, height = 9999, preview_width = 105 }, -- maximize
            vertical = {
                width = 9999, height = 9999, },                                -- maximize
        },
    }
    local telescope_vertical_theme = {
        layout_strategy = "vertical",
        layout_config = {
            preview_cutoff = 1,                 -- dont hide preview on zoomed
            vertical = {
                width = 9999, height = 9999, }, -- maximize
        },
    }
    local telescope_max_columns_horizontal = 120
    if vim.o.columns < telescope_max_columns_horizontal then
        return telescope_vertical_theme
    else
        return telescope_horizontal_theme
    end
end

local function telescope_git_or_find_files()
    local opts = telescope_opts_contextual()
    if git.get_root() ~= nil then
        telescope.git_files(opts)
    else
        telescope.find_files(opts)
    end
end

local function telescope_live_grep_git_or_dir()
    local opts = telescope_opts_contextual()
    local git_root = git.get_root()
    if git_root ~= nil then
        opts["cwd"] = git_root
    end
    telescope.live_grep(opts)
end

local function telescope_buffers()
    local opts = telescope_opts_contextual()
    telescope.buffers(opts)
end

local function telescope_current_buffer_fuzzy_find()
    local opts = telescope_opts_contextual()
    telescope.current_buffer_fuzzy_find(opts)
end

local function telescope_registers()
    local opts = telescope_opts_contextual()
    telescope.registers(opts)
end

local function telescope_lsp_references()
    local opts = telescope_opts_contextual()
    telescope.lsp_references(opts)
end

vim.keymap.set("", "<C-e>", telescope_git_or_find_files)
vim.keymap.set("", "<C-b>", telescope_buffers)
vim.keymap.set("", "<C-g>", telescope_live_grep_git_or_dir)
vim.keymap.set("", "<C-f>", telescope_current_buffer_fuzzy_find)
vim.keymap.set("n", "L", telescope_lsp_references)
vim.keymap.set("", "<leader>r", telescope_registers)

-- copied from telescope-file-browser.nvim
local netrw_bufname
pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    once = true,
    callback = function()
        pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
    end,
})
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("telescope-file-browser", { clear = true }),
    pattern = "*",
    callback = function()
        vim.schedule(function()
            if vim.bo[0].filetype == "netrw" then
                return
            end
            local bufname = vim.api.nvim_buf_get_name(0)
            if vim.fn.isdirectory(bufname) == 0 then
                _, netrw_bufname = pcall(vim.fn.expand, "#:p:h")
                return
            end

            -- prevents reopening of file-browser if exiting without selecting a file
            if netrw_bufname == bufname then
                netrw_bufname = nil
                return
            else
                netrw_bufname = bufname
            end

            -- ensure no buffers remain with the directory name
            local buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
            telescope_git_or_find_files()
        end)
    end,
})
