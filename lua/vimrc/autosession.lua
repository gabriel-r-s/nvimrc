local DEFAULT_SESSION_PATH = ".session.vim"
local autosession_augroup = vim.api.nvim_create_augroup("autosession", { clear = true })

local git = require("vimrc.git")

-- vim.cmd("set sessionoptions-=options")
-- vim.cmd("set sessionoptions-=blank")
--
-- vim.api.nvim_create_autocmd("VimEnter", {
--     group = autosession_augroup,
--     pattern = "*",
--     callback = function()
--         -- no need to re-load the session
--         if vim.v.this_session ~= "" then
--             return
--         end
--         local bufnr = vim.api.nvim_get_current_buf()
--         local cwd = vim.fn.getcwd()
--         if vim.fn.globpath(cwd, DEFAULT_SESSION_PATH) ~= "" then
--             vim.cmd("source " .. DEFAULT_SESSION_PATH)
--         else
--             local git_root = git.get_root()
--             if git_root ~= nil and vim.fn.globpath(git_root, DEFAULT_SESSION_PATH) ~= "" then
--                 vim.cmd("source " .. git_root .. "/" .. DEFAULT_SESSION_PATH)
--             end
--         end
--         if bufnr > 0 then
--             vim.api.nvim_set_current_buf(bufnr)
--         end
--     end,
-- })
--
-- vim.api.nvim_create_autocmd("VimLeave", {
--     group = autosession_augroup,
--     pattern = "*",
--     callback = function()
--         local this_session = vim.v.this_session
--         if this_session ~= "" then
--             vim.cmd("mksession! " .. this_session)
--         else
--             local git_root = git.get_root()
--             if git_root ~= nil then
--                 vim.cmd("mksession " .. git_root .. "/" .. DEFAULT_SESSION_PATH)
--             end
--         end
--     end,
-- })
