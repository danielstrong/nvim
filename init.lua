-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.is_mac = vim.loop.os_uname().sysname == "Darwin"
require("config.lazy")
