-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--

local function augroup(name)
    return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

vim.api.nvim_del_augroup_by_name("lazyvim_checktime")

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- vim.api.nvim_create_autocmd("FileType", {
--     group = augroup("wrap_spell"),
--     pattern = { "plaintex", "typst", "gitcommit", "markdown" },
--     callback = function()
--         vim.opt_local.wrap = true
--         vim.opt_local.spell = true
--     end,
-- })

vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 400, on_macro = true, on_visual = true })
    end,
})

-- vim.api.nvim_del_augroup_by_name("lazyvim_last_loc")
-- vim.api.nvim_create_autocmd("BufReadPost", {
--     group = augroup("remember-cursor-position"),
--     desc = "return cursor to where it was last time closing the file",
--     pattern = "*",
--     command = 'silent! normal! g`"zv',
-- })
