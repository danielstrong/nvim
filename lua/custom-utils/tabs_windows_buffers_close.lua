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

function M.quit_clear_agent_comments()
    if vim.bo.filetype == "markdown" and vim.env.CLAUDE_CODE_ENTRYPOINT == "cli" then
        -- closing when editing a prompt file, delete lines that start with #, and delete empty lines and start and bottom
        vim.cmd([[g/^#/d]])
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local first = 1
        while first <= #lines and lines[first]:match("^%s*$") do
            first = first + 1
        end
        local last = #lines
        while last >= first and lines[last]:match("^%s*$") do
            last = last - 1
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_slice(lines, first, last))
    end
    vim.cmd("x")
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

function M.delete_buffer()
    Snacks.bufdelete()
end

function M.delete_unshown_buffers()
    local shown = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        shown[vim.api.nvim_win_get_buf(win)] = true
    end
    local deleted = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted and not shown[buf] then
            if pcall(vim.api.nvim_buf_delete, buf, { force = false }) then
                deleted = deleted + 1
            end
        end
    end
    vim.notify(("Deleted %d buffer%s"):format(deleted, deleted == 1 and "" or "s"))
end

function M.reload_all_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
            vim.api.nvim_buf_call(buf, function()
                vim.cmd("e")
            end)
        end
    end
end

return M
