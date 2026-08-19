local Snacks = require("snacks")

local M = {}

local function parse_filter(input)
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

--- Builds a reusable "prompt for comma-separated include/exclude glob
--- filters" function (tokens prefixed with "!" are excludes). The returned
--- function remembers every string confirmed this session in `history`
--- (in-memory only, lost on restart), lets <Up>/<C-p> and <Down>/<C-n> cycle
--- through it while typing (preserving any in-progress draft), and lets
--- <Tab> complete filesystem paths for the token under the cursor.
--- `on_confirm(include, exclude)` is called with the parsed glob lists once
--- the user hits Enter (never called on Esc).
--- @param history string[] in-memory history list to read/append to.
--- @param prompt string prompt text shown in the input window.
--- @param on_confirm fun(include: string[], exclude: string[])
local function make_filter_prompt(history, prompt, on_confirm)
    --- @param opts? { prefill?: string } prefill overrides the usual "last confirmed value" default.
    return function(opts)
        opts = opts or {}
        -- index == #history + 1 means "editing the draft" (not viewing a history entry).
        local index = #history + 1
        local draft = ""

        local function set_line(win, text)
            text = text or ""
            vim.api.nvim_buf_set_lines(win.buf, 0, -1, false, { text })
            vim.api.nvim_win_set_cursor(win.win, { 1, #text })
        end

        local win = Snacks.input({
            prompt = prompt,
            default = (opts.prefill and opts.prefill ~= "") and opts.prefill or history[#history],
        }, function(value)
            if value == nil then
                return -- Esc: abort, no history entry
            end
            table.insert(history, value)
            on_confirm(parse_filter(value))
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
            if index > #history then
                draft = vim.api.nvim_buf_get_lines(win.buf, 0, 1, false)[1] or ""
            end
            index = index - 1
            set_line(win, history[index])
        end

        local function hist_down()
            if vim.fn.pumvisible() == 1 then
                feed("<C-n>")
                return
            end
            if index > #history then
                return
            end
            index = index + 1
            set_line(win, index > #history and draft or history[index])
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
end

-- In-memory only (cleared on restart), one history per filter prompt.
local grep_filter_history = {}
local file_filter_history = {}

--- Prompt for include/exclude filters, then run Snacks.picker.grep() restricted to them.
M.grep_with_filter_prompt = make_filter_prompt(
    grep_filter_history,
    "Grep filter (comma-separated globs, prefix with ! to exclude)",
    function(include, exclude)
        Snacks.picker.grep({
            args = { "--fixed-strings" },
            glob = include[1] and include or nil,
            exclude = exclude[1] and exclude or nil,
        })
    end
)

--- Prompt for include/exclude filters, then run Snacks.picker.files() restricted to them.
--- Forces the ripgrep backend (`cmd = "rg"`) so the include/exclude globs get
--- the same multi `-g`/`-g '!...'` semantics as the grep filter above,
--- regardless of whether `fd` is otherwise preferred for plain file search.
M.files_with_filter_prompt = make_filter_prompt(
    file_filter_history,
    "File filter (comma-separated globs, prefix with ! to exclude)",
    function(include, exclude)
        local args = {}
        for _, pattern in ipairs(include) do
            table.insert(args, "-g")
            table.insert(args, pattern)
        end
        for _, pattern in ipairs(exclude) do
            table.insert(args, "-g")
            table.insert(args, "!" .. pattern)
        end
        Snacks.picker.files({ cmd = "rg", args = args })
    end
)

--- Builds a comma-separated prefill string from an explorer picker's
--- selected items (falling back to the item under the cursor if nothing is
--- multi-selected), turning directories into `dir/**` so they work as globs.
--- @param picker snacks.Picker
function M.explorer_selection_prefill(picker)
    local tokens = {}
    for _, item in ipairs(picker:selected({ fallback = true })) do
        local path = Snacks.picker.util.path(item)
        if path then
            local rel = vim.fn.fnamemodify(path, ":.")
            table.insert(tokens, item.dir and (rel .. "/**") or rel)
        end
    end
    return table.concat(tokens, ", ")
end

return M
