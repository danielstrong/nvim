local M = {}

local clue_grid_ns = vim.api.nvim_create_namespace("custom_buffer_numbers_clue_grid")

-- Fill order for the <localleader>b clue grid: "column" goes top-to-bottom
-- then moves to the next column; "row" goes left-to-right then wraps to the
-- next row. Change this to switch the direction.
M.grid_fill_direction = "column"
-- M.grid_fill_direction = "row"

-- How much of a buffer's path to show. 0 shows just the file name
-- (`keymaps.lua`); N shows up to N parent folders with `…/` for anything
-- truncated (`…/config/keymaps.lua` for N = 1); negative or nil shows the
-- full relative path (current behavior).
-- M.buffer_name_compact_levels = nil
M.buffer_name_compact_levels = 2

function M.bufname(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then
        return "[No Name]"
    end

    local levels = M.buffer_name_compact_levels
    if levels == nil or levels < 0 then
        return vim.fn.fnamemodify(name, ":~:.")
    end
    if levels == 0 then
        return vim.fn.fnamemodify(name, ":t")
    end

    local parts = vim.split(vim.fn.fnamemodify(name, ":~:."), "/", { plain = true })
    local filename = table.remove(parts)
    local n_parents = math.min(levels, #parts)
    local kept = vim.list_slice(parts, #parts - n_parents + 1)
    table.insert(kept, filename)

    local result = table.concat(kept, "/")
    return n_parents < #parts and ("…/" .. result) or result
end

local function is_listed(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
end

-- Stable per-session numbering: buffers keep the slot they were assigned
-- last time, so a slot only shifts when a buffer is created/deleted, never
-- when you switch buffers. New buffers are appended in bufnr (creation)
-- order; `M.move_current_buf_to` lets you pin a buffer to a specific slot,
-- overriding this default ordering.
M.order = nil

function M.listed_buffers_sorted()
    local listed = vim.tbl_filter(is_listed, vim.api.nvim_list_bufs())
    table.sort(listed)

    local seen = {}
    local order = {}
    for _, buf in ipairs(M.order or {}) do
        if is_listed(buf) then
            table.insert(order, buf)
            seen[buf] = true
        end
    end
    for _, buf in ipairs(listed) do
        if not seen[buf] then
            table.insert(order, buf)
        end
    end

    M.order = order
    return order
end

function M.switch_to_buf(i)
    local buf = M.listed_buffers_sorted()[i]
    if not buf then
        vim.notify("No buffer " .. i, vim.log.levels.WARN)
        return
    end
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_echo({ { "Switch to Buffer " .. i .. ": " .. M.bufname(buf), "None" } }, false, {})
end

-- Pins the current buffer to slot `i`, swapping it with whatever buffer
-- currently occupies that slot (which takes the mover's old slot), like
-- swapping window/tab positions.
function M.move_current_buf_to(i)
    local order = M.listed_buffers_sorted()
    if i < 1 or i > #order then
        vim.notify(("No buffer slot %d (only %d open)"):format(i, #order), vim.log.levels.WARN)
        return
    end

    local cur = vim.api.nvim_get_current_buf()
    local from_idx
    for idx, buf in ipairs(order) do
        if buf == cur then
            from_idx = idx
            break
        end
    end
    if not from_idx or from_idx == i then
        return
    end

    order[from_idx], order[i] = order[i], order[from_idx]
    M.order = order
    M.update_clue_descs()
    vim.api.nvim_echo({ { "Buffer " .. i .. ": " .. M.bufname(cur), "None" } }, false, {})
end

-- Detects the <localleader>b clue window (identified by its "Switch to ..."
-- entries) and rewrites it to lay every entry out left-to-right, wrapping to
-- further rows as needed, in a window spanning 95% of the screen width,
-- centered, along the top. Returns a window config table to use for it,
-- or nil if `lines` isn't that window.
function M.clue_grid_window_config(buf_id, lines)
    local entries = {}
    local is_buffer_clue = false
    for _, line in ipairs(lines) do
        local key, desc = line:match("^ (%S+) │ (.*)$")
        if key then
            local short_desc = desc:match("^Switch to (.*)$")
            if short_desc then
                is_buffer_clue = true
                desc = short_desc
            end
            table.insert(entries, { key = key, desc = desc, text = key .. " │ " .. desc })
        end
    end

    if not is_buffer_clue then
        return nil
    end

    local width = math.floor(vim.o.columns * 0.95)
    local max_width = width - 4
    local gap = 3

    local entry_width = 0
    for _, entry in ipairs(entries) do
        entry_width = math.max(entry_width, vim.fn.strdisplaywidth(entry.text))
    end

    local has_statusline = vim.o.laststatus > 0
    local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
    local avail_height = vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0) - (has_statusline and 1 or 0) - 2

    -- Fixed column width (based on the widest entry) so every entry lines up
    -- in a grid instead of a free-flowing wrap.
    local max_cols = math.max(1, math.min(#entries, math.floor((max_width + gap) / (entry_width + gap))))
    local row_major = M.grid_fill_direction == "row"
    local cols, num_rows

    if not row_major then
        -- Prefer stacking into up to 9 rows, so the buffer-number keymaps
        -- (1..9) line up in a single column, as long as it still fits.
        local preferred_rows = math.min(9, #entries, avail_height)
        local preferred_cols = math.ceil(#entries / preferred_rows)
        if preferred_cols <= max_cols then
            num_rows, cols = preferred_rows, preferred_cols
        end
    end
    if not num_rows then
        cols = max_cols
        num_rows = math.ceil(#entries / cols)
    end

    -- Fill order depends on `M.grid_fill_direction`, tracking each cell's
    -- byte offset so it can be highlighted afterwards.
    local rows, row_marks = {}, {}
    for r = 1, num_rows do
        rows[r] = ""
        row_marks[r] = {}
    end
    for i, entry in ipairs(entries) do
        local col, r
        if row_major then
            r = math.floor((i - 1) / cols) + 1
            col = (i - 1) % cols
        else
            col = math.floor((i - 1) / num_rows)
            r = (i - 1) % num_rows + 1
        end
        if col > 0 then
            rows[r] = rows[r] .. string.rep(" ", gap)
        end
        local col_start = #rows[r]
        local pad = entry_width - vim.fn.strdisplaywidth(entry.text)
        rows[r] = rows[r] .. entry.text .. string.rep(" ", pad)
        table.insert(row_marks[r], { col_start = col_start, key_len = #entry.key, text_len = #entry.text })
    end

    vim.api.nvim_buf_clear_namespace(buf_id, -1, 0, -1)
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, rows)

    -- Re-apply the same highlight groups the normal clue window uses
    -- (MiniClueNextKey / MiniClueSeparator / MiniClueDescSingle), positioned
    -- per cell instead of spanning the whole line.
    local function set_hl(row, col_from, col_to, hl_group)
        vim.api.nvim_buf_set_extmark(buf_id, clue_grid_ns, row, col_from, { end_col = col_to, hl_group = hl_group })
    end
    for r, marks in ipairs(row_marks) do
        for _, mark in ipairs(marks) do
            local sep_start = mark.col_start + mark.key_len + 1 -- skip the space before │
            local desc_start = sep_start + 4 -- │ (3 bytes) + the space after it
            set_hl(r - 1, mark.col_start, mark.col_start + mark.key_len, "MiniClueNextKey")
            set_hl(r - 1, sep_start, sep_start + 3, "MiniClueSeparator")
            set_hl(r - 1, desc_start, mark.col_start + mark.text_len, "MiniClueDescSingle")
        end
    end

    local height = math.max(1, math.min(#rows, avail_height))
    local is_scrollable = height < #rows

    return {
        width = width,
        height = height,
        anchor = "NW",
        row = "auto",
        col = math.floor((vim.o.columns - width) / 2),
        border = "rounded",
        title_pos = "left",
        footer = is_scrollable and "  <C-d>/<C-u> ▼/▲  " or nil,
        footer_pos = is_scrollable and "center" or nil,
    }
end

function M.update_clue_descs()
    local ok_clue, miniclue = pcall(require, "mini.clue")
    if not ok_clue then
        return
    end
    local bufs = M.listed_buffers_sorted()
    for i = 1, 9 do
        local buf = bufs[i]
        local desc = buf and ("Switch to " .. M.bufname(buf)) or ""
        for _, mode in ipairs({ "n", "x" }) do
            pcall(miniclue.set_mapping_desc, mode, "<localleader>b" .. i, desc)
        end
    end
end

return M
