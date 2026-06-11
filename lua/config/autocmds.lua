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
        (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 400, on_macro = true, on_visual = true })
    end,
})

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
                break
            end
        end
        if not has_md then
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
vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup("colorscheme"),
    pattern = "*",
    callback = function()
        --
        -- vim.cmd([[
        --     hi StatusLine         ctermbg=darkgray ctermfg=black guibg=#cccccc guifg=#090909
        --     hi StatusLineNC       ctermbg=black ctermfg=darkgray guibg=#cccccc guifg=#090909
        --     hi StatusLineSection  ctermbg=darkgray ctermfg=black guibg=#cccccc guifg=#090909
        --     hi StatusLineSectionV ctermbg=darkyellow ctermfg=black guibg=#f4bf75 guifg=#090909
        --     hi StatusLineSectionI ctermbg=darkgreen ctermfg=black guibg=#90a959 guifg=#090909
        --     hi StatusLineSectionC ctermbg=darkblue ctermfg=black guibg=#6a9fb5 guifg=#090909
        --     hi StatusLineSectionR ctermbg=green ctermfg=black guibg=#aac474 guifg=#090909
        --     hi Conceal            cterm=underline ctermbg=black ctermfg=lightgray term=underline guibg=#090909 guifg=#cccccc
        -- ]])
        --
        vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cccccc", bg = "#090909" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#cccccc", bg = "#090909" })
        vim.api.nvim_set_hl(0, "StatusLineSection", { fg = "#cccccc", bg = "#090909" })
        vim.api.nvim_set_hl(0, "StatusLineSectionV", { fg = "#f4bf75", bg = "#090909" })
        vim.api.nvim_set_hl(0, "StatusLineSectionI", { fg = "#90a959", bg = "#090909" })
        vim.api.nvim_set_hl(0, "StatusLineSectionC", { fg = "#6a9fb5", bg = "#090909" })
        vim.api.nvim_set_hl(0, "StatusLineSectionR", { fg = "#aac474", bg = "#090909" })
        vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#6a9fb5" })
        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#cccccc", italic = true })
        -- vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#909090", italic = true })

        if vim.g.colors_name == "neosolarized" then
            vim.api.nvim_set_hl(0, "CursorLine", { bg = "#053040" })
        end
        -- // hjio there
        if vim.g.colors_name ~= nil and vim.g.colors_name:find("kanagawa") then
            vim.api.nvim_set_hl(0, "SpellBad", { fg = "#E82424" })
            vim.api.nvim_set_hl(0, "SpellCap", { fg = "#FF9E3B" })
            vim.api.nvim_set_hl(0, "SpellRare", { fg = "#7E9CD8" })
            vim.api.nvim_set_hl(0, "SpellLocal", { fg = "#98BB6C" })
        end
    end,
})
