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
-- vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "BufEnter", "CursorHold" }, {
--     group = augroup("checktime"),
--     callback = function()
--         if vim.o.buftype ~= "nofile" then
--             vim.cmd("checktime")
--         end
--     end,
-- })
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = augroup("checktime"),
    callback = function()
        local file = vim.fn.fnamemodify(vim.fn.expand("<afile>"), ":~:.")
        local reason = vim.v.fcs_reason
        vim.notify(file .. " changed on disk " .. reason, vim.log.levels.INFO)
    end,
})

-- vim.api.nvim_create_autocmd("FileChangedShell", {
--     group = augroup("checktime"),
--     callback = function()
--         local file = vim.fn.fnamemodify(vim.fn.expand("<afile>"), ":~:.")
--         local reason = vim.v.fcs_reason
--
--         if reason == "conflict" then
--             vim.v.fcs_choice = ""
--             vim.notify(file .. " changed on disk — NOT reloaded (local changes)", vim.log.levels.WARN)
--         elseif reason == "deleted" then
--             vim.v.fcs_choice = ""
--             vim.notify(file .. " was deleted on disk — buffer kept", vim.log.levels.WARN)
--         elseif reason == "changed" then
--             vim.v.fcs_choice = "reload"
--             vim.notify(file .. " changed on disk, buffer reloaded", vim.log.levels.INFO)
--         else
--             vim.v.fcs_choice = "reload"
--         end
--     end,
-- })

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
        (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 250, on_macro = true, on_visual = true })
    end,
})

-- Use visual mode (not select mode) for snippet placeholder selections
-- vim.api.nvim_create_autocmd("ModeChanged", {
--     group = augroup("snippet_visual_mode"),
--     pattern = { "*:s", "*:S", "*:\x13" }, -- entering select / S-line / S-block
--     callback = function()
--         vim.api.nvim_feedkeys(vim.keycode("<C-g>"), "n", false)
--     end,
-- })

vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("startup_md_wrap_spell"),
    callback = function()
        local args = vim.fn.argv()
        if type(args) ~= "table" or #args == 0 then
            return
        end
        local has_md = false
        for _, name in ipairs(args) do
            if type(name) == "string" and name:lower():match("%.md$") then
                has_md = true
                -- normally markdown files show but i dont want it for claude code edits
                if vim.env.CLAUDE_CODE_ENTRYPOINT ~= "cli" then
                    -- vim.o.laststatus = 2
                    vim.cmd("f")
                end
                break
            end
        end
        if not has_md then
            -- non markdown files and markdown files that arent opened through claudecode get laststatus=2 to start with the status
            -- vim.o.laststatus = 2
            vim.cmd("f")
            return
        end
        vim.g.blink_tab_show = false
        vim.g.blink_auto_show = false
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local bname = vim.api.nvim_buf_get_name(buf)
            if bname ~= "" and bname:lower():match("%.md$") then
                for _, win in ipairs(vim.fn.win_findbuf(buf)) do
                    vim.wo[win].spell = true
                    vim.wo[win].wrap = true
                end
            end
        end
    end,
})

-- vim.api.nvim_del_augroup_by_name("lazyvim_last_loc")
-- vim.api.nvim_create_autocmd("BufReadPost", {
--     group = augroup("remember-cursor-position"),
--     desc = "return cursor to where it was last time closing the file",
--     pattern = "*",
--     command = 'silent! normal! g`"zv',
-- })
--
--
--#region

-- Lsp progress in the statusline
require("config.lsp_progress").setup()
