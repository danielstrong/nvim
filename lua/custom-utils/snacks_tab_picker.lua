local Snacks = require("snacks")

local M = {}

local CONTEXT_LINES = 5 -- lines of context above/below the cursor to show per split

--- Return the lines around the cursor in `win` (CONTEXT_LINES above/below),
--- each prefixed with its line number and a marker on the cursor line.
local function get_context_lines(win)
    local buf = vim.api.nvim_win_get_buf(win)
    local cursor = vim.api.nvim_win_get_cursor(win)
    local row = cursor[1] -- 1-indexed
    local total = vim.api.nvim_buf_line_count(buf)
    local start_line = math.max(1, row - CONTEXT_LINES)
    local end_line = math.min(total, row + CONTEXT_LINES)

    local ok, lines = pcall(vim.api.nvim_buf_get_lines, buf, start_line - 1, end_line, false)
    if not ok then
        return { "<unable to read buffer>" }
    end

    local out = {}
    for offset, line in ipairs(lines) do
        local lnum = start_line + offset - 1
        local marker = (lnum == row) and "-> " or "   "
        table.insert(out, ("%s%4d %s"):format(marker, lnum, line))
    end
    return out
end

--- Build a single text preview that concatenates the cursor context of every
--- window/split in the tab, separated by headers.
local function build_concat_preview(i, wins, cur_win)
    local preview_lines = {}
    table.insert(preview_lines, ("Tab %d: %d window%s"):format(i, #wins, #wins == 1 and "" or "s"))
    table.insert(preview_lines, string.rep("=", 40))

    for _, win in ipairs(wins) do
        local win_buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(win_buf)
        if bufname == "" then
            bufname = "[No Name]"
        end
        bufname = vim.fn.fnamemodify(bufname, ":~:.") -- relative to cwd, or ~
        local win_marker = (win == cur_win) and "-> " or "   "

        table.insert(preview_lines, "")
        table.insert(preview_lines, ("%s%s"):format(win_marker, bufname))
        table.insert(preview_lines, string.rep("-", 40))

        vim.list_extend(preview_lines, get_context_lines(win))
    end

    return {
        text = table.concat(preview_lines, "\n"),
        ft = "text",
    }
end

--- @param preview_mode "current"|"concat" "current" always shows only the active
--- window's buffer (with real syntax highlighting). "concat" shows the normal
--- single-buffer preview for tabs with only one window, but for tabs with
--- multiple splits shows a text preview concatenating the cursor context of
--- each split.
local function get_tabs(preview_mode)
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

        local item = {
            idx = i,
            text = ("Tab %d: %s"):format(i, name),
            tabnr = i,
            tabpage = tabpage,
            preview_title = ("Tab %d: %s (%d window%s)"):format(i, name, #wins, #wins == 1 and "" or "s"),
        }

        if preview_mode == "concat" and #wins > 1 then
            item.preview = build_concat_preview(i, wins, cur_win)
        else
            -- single window in the tab, or "current" mode: just show the
            -- active buffer with real syntax highlighting.
            item.buf = buf
            item.file = vim.api.nvim_buf_get_name(buf)
            item.pos = vim.api.nvim_win_get_cursor(cur_win)
            item.preview = "file"
        end

        table.insert(tabs, item)
    end
    return tabs
end

--- @param opts? { preview_mode?: "current"|"concat" } preview_mode defaults to
--- "current" (always shows only the focused window's buffer). Use "concat" to
--- see every split in a tab concatenated into one preview (tabs with a single
--- window still just show that buffer normally).
function M.tabs_picker(opts)
    opts = opts or {}
    local preview_mode = opts.preview_mode or "current"

    local items = get_tabs(preview_mode)
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
        -- "preview" delegates to the normal file preview when item.preview == "file",
        -- and otherwise renders item.preview.text/ft (used for the concat case).
        preview = "preview",
        actions = {
            open_tab = function(picker, item)
                picker:close()
                vim.cmd(("tabnext %d"):format(item.tabnr))
            end,
            close_tab = function(picker, item)
                -- picker:close()
                vim.cmd(("tabclose %d"):format(item.tabnr))
            end,
        },
        win = {
            list = {
                keys = {
                    ["d"] = "close_tab",
                    ["o"] = "open_tab",
                    ["h"] = "list_up",
                    ["l"] = "list_down",
                },
            },
        },
    })
end

return M
