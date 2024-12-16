local DIR_GIT_ROOT
if DIR_GIT_ROOT == nil then
    DIR_GIT_ROOT = {}
end

function get_root()
    local cwd = vim.fn.getcwd()
    -- cache result in local object, recompute if cwd changed
    if DIR_GIT_ROOT[cwd] == nil then
        local cmd = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true })
        local result = cmd:wait()
        if result.code == 0 then
            -- trim surrounding whitespace
            local git_root = result.stdout:gsub("^%s+", ""):gsub("%s+$", "")
            assert(git_root ~= "" and git_root ~= nil, "Failed to find git root!")
            DIR_GIT_ROOT[cwd] = git_root
        end
    end
    return DIR_GIT_ROOT[cwd]
end

return {
    get_root = get_root,
}
