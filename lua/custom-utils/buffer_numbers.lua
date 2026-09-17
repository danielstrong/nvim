local M = {}

function M.bufname(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    return name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
end

-- Stable per-session numbering: sorted by bufnr (creation order), full
-- listed-buffer list (current buffer included), so a slot only shifts when
-- a buffer is created/deleted, never when you switch buffers.
function M.listed_buffers_sorted()
    local bufs = vim.tbl_filter(function(buf)
        return vim.bo[buf].buflisted
    end, vim.api.nvim_list_bufs())
    table.sort(bufs)
    return bufs
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
            table.insert(entries, key .. " │ " .. desc)
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
        entry_width = math.max(entry_width, vim.fn.strdisplaywidth(entry))
    end

    -- Fixed column width (based on the widest entry) so every entry lines up
    -- in a grid instead of a free-flowing wrap.
    local cols = math.max(1, math.min(#entries, math.floor((max_width + gap) / (entry_width + gap))))
    local num_rows = math.ceil(#entries / cols)

    -- Fill top-to-bottom within a column, then move to the next column.
    local rows = {}
    for r = 1, num_rows do
        rows[r] = ""
    end
    for i, entry in ipairs(entries) do
        local col = math.floor((i - 1) / num_rows)
        local r = (i - 1) % num_rows + 1
        local cell = entry .. string.rep(" ", entry_width - vim.fn.strdisplaywidth(entry))
        rows[r] = col == 0 and cell or (rows[r] .. string.rep(" ", gap) .. cell)
    end

    vim.api.nvim_buf_clear_namespace(buf_id, -1, 0, -1)
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, rows)

    local has_statusline = vim.o.laststatus > 0
    local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
    local avail_height = vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0) - (has_statusline and 1 or 0) - 2
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
        local desc = buf and ("Switch to " .. M.bufname(buf)) or ("Switch to buffer " .. i)
        for _, mode in ipairs({ "n", "x" }) do
            pcall(miniclue.set_mapping_desc, mode, "<localleader>b" .. i, desc)
        end
    end
end

return M
