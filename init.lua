require("vimrc.set")
require("vimrc.mappings")

local load_plugins = true
for _, arg in pairs(vim.v.argv) do
    if arg == "--noplugin" then
        load_plugins = false
        break
    end
end

if load_plugins then
    require("vimrc.undofile")
    require("vimrc.dotfiles")
    require("vimrc.git")
    require("vimrc.autosession")
    require("vimrc.plugins")
else
    require("vimrc.no-plugins")
end
