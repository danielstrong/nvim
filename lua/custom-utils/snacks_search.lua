local Snacks = require("snacks")

local M = {}

-- In-memory only (cleared on restart): raw strings the user has confirmed via grep_with_filter_prompt.
local grep_filter_history = {}

local function parse_grep_filter(input)
    local include, exclude = {}, {}
    for token in (input .. ","):gmatch("([^,]*),") do
        token = token:match("^%s*(.-)%s*$")
        if token ~= "" then
            if token:sub(1, 1) == "!" then
                local pattern = token:sub(2):match("^%s*(.-)%s*$")
                if pattern ~= "" then
                    table.insert(exclude, pattern)
                end
            else
                table.insert(include, token)
            end
        end
    end
    return include, exclude
end

--- Prompt for comma-separated include/exclude glob filters (tokens prefixed
--- with "!" are excludes), then run Snacks.picker.grep() restricted to them.
--- Remembers every string confirmed this session (lost on restart) and lets
--- <Up>/<C-p> and <Down>/<C-n> cycle through that history while typing.
function M.grep_with_filter_prompt()
    -- index == #grep_filter_history + 1 means "editing the draft" (not viewing a history entry).
    local index = #grep_filter_history + 1
    local draft = ""

    local function set_line(win, text)
        text = text or ""
        vim.api.nvim_buf_set_lines(win.buf, 0, -1, false, { text })
        vim.api.nvim_win_set_cursor(win.win, { 1, #text })
    end

    local win = Snacks.input({
        prompt = "Grep filter (comma-separated globs, prefix with ! to exclude)",
        default = grep_filter_history[#grep_filter_history],
    }, function(value)
        if value == nil then
            return -- Esc: abort, no history entry
        end
        table.insert(grep_filter_history, value)
        local include, exclude = parse_grep_filter(value)
        Snacks.picker.grep({
            args = { "--fixed-strings" },
            glob = include[1] and include or nil,
            exclude = exclude[1] and exclude or nil,
        })
    end)

    -- Discards any in-progress edit of a recalled entry when navigating further (standard readline behavior).
    local function hist_up()
        if index == 1 then
            return
        end
        if index > #grep_filter_history then
            draft = vim.api.nvim_buf_get_lines(win.buf, 0, 1, false)[1] or ""
        end
        index = index - 1
        set_line(win, grep_filter_history[index])
    end

    local function hist_down()
        if index > #grep_filter_history then
            return
        end
        index = index + 1
        set_line(win, index > #grep_filter_history and draft or grep_filter_history[index])
    end

    for _, mode in ipairs({ "i", "n" }) do
        vim.keymap.set(mode, "<Up>", hist_up, { buffer = win.buf })
        vim.keymap.set(mode, "<C-p>", hist_up, { buffer = win.buf })
        vim.keymap.set(mode, "<Down>", hist_down, { buffer = win.buf })
        vim.keymap.set(mode, "<C-n>", hist_down, { buffer = win.buf })
    end
end

return M
