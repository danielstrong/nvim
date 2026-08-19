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

local function feed(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

--- The byte-offset (1-based, for vim.fn.complete) and text of the path
--- currently being typed at the cursor: the portion of the comma-separated
--- field after the last comma, skipping leading whitespace and a leading "!".
local function current_token_base(win)
    local cursor = vim.api.nvim_win_get_cursor(win.win)
    local line = vim.api.nvim_buf_get_lines(win.buf, 0, 1, false)[1] or ""
    local before_cursor = line:sub(1, cursor[2])

    local token_start = 0
    for i = #before_cursor, 1, -1 do
        if before_cursor:sub(i, i) == "," then
            token_start = i
            break
        end
    end
    local token = before_cursor:sub(token_start + 1)
    local ws_len = #token - #(token:gsub("^%s+", ""))
    local after_ws = token:sub(ws_len + 1)
    local bang_len = after_ws:sub(1, 1) == "!" and 1 or 0
    local base = after_ws:sub(bang_len + 1)

    return token_start + ws_len + bang_len + 1, base
end

--- Prompt for comma-separated include/exclude glob filters (tokens prefixed
--- with "!" are excludes), then run Snacks.picker.grep() restricted to them.
--- Remembers every string confirmed this session (lost on restart) and lets
--- <Up>/<C-p> and <Down>/<C-n> cycle through that history while typing.
--- <Tab> completes filesystem paths for the token under the cursor.
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
        if vim.fn.pumvisible() == 1 then
            feed("<C-p>")
            return
        end
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
        if vim.fn.pumvisible() == 1 then
            feed("<C-n>")
            return
        end
        if index > #grep_filter_history then
            return
        end
        index = index + 1
        set_line(win, index > #grep_filter_history and draft or grep_filter_history[index])
    end

    local function complete_path()
        if vim.fn.pumvisible() == 1 then
            feed("<C-n>")
            return
        end
        local startcol, base = current_token_base(win)
        local ok, matches = pcall(vim.fn.getcompletion, base, "file")
        if ok and #matches > 0 then
            vim.fn.complete(startcol, matches)
        end
    end

    vim.keymap.set("i", "<Tab>", complete_path, { buffer = win.buf })
    for _, mode in ipairs({ "i", "n" }) do
        vim.keymap.set(mode, "<Up>", hist_up, { buffer = win.buf })
        vim.keymap.set(mode, "<C-p>", hist_up, { buffer = win.buf })
        vim.keymap.set(mode, "<Down>", hist_down, { buffer = win.buf })
        vim.keymap.set(mode, "<C-n>", hist_down, { buffer = win.buf })
    end
end

return M
