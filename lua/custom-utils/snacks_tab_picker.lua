local Snacks = require("snacks")

local M = {}

local function get_tabs()
    local tabs = {}
    local tabpages = vim.api.nvim_list_tabpages()
    for i, tabpage in ipairs(tabpages) do
        local wins = vim.api.nvim_tabpage_list_wins(tabpage)
        local cur_win = vim.api.nvim_tabpage_get_win(tabpage)
        local buf = vim.api.nvim_win_get_buf(cur_win)
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
        if name == "" then
            name = "[No Name]"
        end

        local cursor_pos = vim.api.nvim_win_get_cursor(cur_win)

        table.insert(tabs, {
            idx = i,
            text = ("Tab %d: %s"):format(i, name),
            tabnr = i,
            tabpage = tabpage,
            buf = buf,
            file = vim.api.nvim_buf_get_name(buf),
            pos = cursor_pos,
            preview_title = ("Tab %d: %s (%d window%s)"):format(i, name, #wins, #wins == 1 and "" or "s"),
        })
    end
    return tabs
end

function M.tabs_picker()
    local items = get_tabs()
    local cur_tabpage = vim.api.nvim_get_current_tabpage()
    Snacks.picker({
        title = "Tabs",
        focus = "list",
        items = items,
        format = "text",
        on_show = function(picker)
            for i, item in ipairs(items) do
                if item.tabpage == cur_tabpage then
                    picker.list:view(i)
                    break
                end
            end
        end,
        confirm = function(picker, item)
            picker:close()
            vim.cmd(("tabnext %d"):format(item.tabnr))
        end,
        preview = "file",
        actions = {
            open_tab = function(picker, item)
                picker:close()
                vim.cmd(("tabnext %d"):format(item.tabnr))
            end,
            close_tab = function(picker, item)
                picker:close()
                vim.cmd(("tabclose %d"):format(item.tabnr))
            end,
        },
        win = {
            list = {
                keys = {
                    ["d"] = "close_tab",
                    ["o"] = "open_tab",
                },
            },
        },
    })
end

return M
