local Snacks = require("snacks")

local M = {}

function M.real_win_count()
    local count = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
            if ft ~= "NvimTree" then
                count = count + 1
            end
        end
    end
    return count
end

function M.real_tab_count()
    return vim.fn.tabpagenr("$")
end

function M.real_wins_showing_current_buf_count()
    local cur = vim.api.nvim_get_current_buf()
    local showing = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == "" and vim.api.nvim_win_get_buf(win) == cur then
            showing = showing + 1
        end
    end
    return showing
end

function M.real_is_only_nvimtree_remaining()
    local count = 0
    local nvimtreecount = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
            if ft ~= "NvimTree" then
                count = count + 1
            else
                nvimtreecount = nvimtreecount + 1
            end
        end
    end
    return count == 0 and nvimtreecount == 1
end

function M.real_quit_window()
    vim.cmd("quit")
    if M.real_is_only_nvimtree_remaining() then
        vim.cmd("quit")
    end
end

function M.real_quit_window_without_closing_nvim()
    if M.real_tab_count() == 1 and M.real_win_count() == 1 then
        vim.notify("Can't close the last window", vim.log.levels.WARN)
        return
    end
    vim.cmd("quit")
    if M.real_tab_count() > 1 and M.real_is_only_nvimtree_remaining() then
        vim.cmd("quit")
    end
end

function M.real_delete_buffer_without_closing_nvim()
    if M.real_tab_count() == 1 and M.real_win_count() == 1 then
        vim.notify("Can't close the last window", vim.log.levels.WARN)
        return
    end
    if M.real_wins_showing_current_buf_count() > 1 then
        vim.cmd("quit")
        return
    end
    Snacks.bufdelete()
    if M.real_tab_count() > 1 and M.real_is_only_nvimtree_remaining() then
        Snacks.bufdelete()
    end
end
return M
