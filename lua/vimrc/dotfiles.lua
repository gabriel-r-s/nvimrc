-- resourcing dotfiles
vim.cmd("autocmd BufWritePost .Xresources !xrdb ~/.Xresources")
vim.cmd(
    "autocmd BufWritePost .config/i3/config !i3-msg reload && notify-send --expire-time=1500 --icon=i3 'Reloaded configuration'")
