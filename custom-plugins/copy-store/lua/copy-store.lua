local M = {}

local state = { extra_dirs = {} }

function M.setup(opts)
    opts = opts or {}
    state.extra_dirs = opts.extra_dirs or {}
end

local function copies_dir()
    return vim.fn.stdpath("config") .. "/custom-plugins/copy-store/copies"
end

-- Ordered list of source dirs as { dir = <expanded abs>, label = <string> }.
-- copies_dir() first (label "copies"), then each configured extra dir with ~
-- expanded (label = the original configured string). Missing extra dirs warn
-- and are skipped.
local function source_dirs()
    local sources = { { dir = copies_dir(), label = "copies" } }
    for _, dir in ipairs(state.extra_dirs) do
        local expanded = vim.fn.expand(dir)
        if vim.fn.isdirectory(expanded) == 1 then
            table.insert(sources, { dir = expanded, label = dir })
        else
            vim.notify("copy-store: extra dir not found: " .. dir, vim.log.levels.WARN)
        end
    end
    return sources
end

-- Like source_dirs() but NEVER drops missing extra dirs (we mkdir on save).
-- copies_dir() first (label "copies"), then each configured extra dir
-- (expanded path, original string as label).
local function save_target_dirs()
    local targets = { { dir = copies_dir(), label = "copies" } }
    for _, dir in ipairs(state.extra_dirs) do
        table.insert(targets, { dir = vim.fn.expand(dir), label = dir })
    end
    return targets
end

-- Picker items gathered recursively from every source dir. `text` (the
-- filename) drives fuzzy matching; `file` drives the "file" formatter and
-- preview via Snacks.picker.util.path(). `comment` shows the source label,
-- as rendered by the "file" formatter alongside `formatters.file.filename_only`.
local function list_copy_items()
    local items = {}
    for _, src in ipairs(source_dirs()) do
        for _, path in ipairs(vim.fn.globpath(src.dir, "**/*", false, true)) do
            local ext = path:match("%.([^./]+)$")
            if vim.fn.isdirectory(path) == 0 and (ext == "md" or ext == "txt") then
                table.insert(items, {
                    text = vim.fn.fnamemodify(path, ":t"),
                    file = path,
                    -- comment = "(" .. src.label .. ")",
                })
            end
        end
    end
    table.sort(items, function(a, b)
        return a.text < b.text
    end)
    return items
end

local function file_exists(dir, name)
    return vim.fn.filereadable(dir .. "/" .. name) == 1
end

local function sanitize_name(input)
    input = vim.trim(input or "")
    if input == "" then
        return nil
    end
    local ext = input:match("%.([^.]+)$")
    local base
    if ext then
        base = input:sub(1, #input - #ext - 1)
    else
        base = input
        ext = "md"
    end
    base = base:gsub("[^%w%-]", "-")
    base = base:gsub("%-+", "-")
    base = base:gsub("^%-+", ""):gsub("%-+$", "")
    if base == "" then
        return nil
    end
    return base .. "." .. ext
end

-- Opens a centered native float backed by a NORMAL file buffer at `path`.
-- For a new copy, `lines` seeds the (not-yet-on-disk) buffer and `modified=true`.
-- For editing, omit lines/modified; the file is loaded from disk as-is.
-- Saving/quitting use the user's normal global keybinds (no custom maps/autocmds).
local function open_editor_float(opts)
    local buf = vim.fn.bufadd(opts.path)
    vim.fn.bufload(buf)
    vim.bo[buf].buftype = ""
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].modifiable = true
    vim.bo[buf].swapfile = false

    if opts.lines then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.lines)
        vim.bo[buf].modified = opts.modified == true
    end

    if vim.bo[buf].filetype == "" then
        vim.bo[buf].filetype = "markdown"
    end

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        -- style = "minimal",
        border = "rounded",
        title = opts.title or " Copy Store ",
        title_pos = "center",
    })

    vim.wo[win].number = true
    vim.wo[win].relativenumber = false
    vim.wo[win].wrap = true
    vim.wo[win].spell = true
    -- vim.wo[win].winhighlight = "NormalFloat:Normal,FloatBorder:Normal"
    -- vim.wo[win].winhighlight = "NormalFloat:Normal"
end

-- Prompt for a name in `dir`, sanitize, re-prompt on invalid/collision, then
-- mkdir the dir and open the seeded float at the chosen path (unsaved).
local function new_copy_name_flow(dir, lines)
    vim.ui.input({ prompt = "Save copy as: " }, function(input)
        if input == nil then
            return
        end
        local name = sanitize_name(input)
        if not name then
            vim.notify("Invalid name", vim.log.levels.ERROR)
            return new_copy_name_flow(dir, lines)
        end
        if file_exists(dir, name) then
            vim.notify("'" .. name .. "' already exists, choose another name", vim.log.levels.ERROR)
            return new_copy_name_flow(dir, lines)
        end
        vim.fn.mkdir(dir, "p")
        open_editor_float({
            title = " New Copy ",
            path = dir .. "/" .. name,
            lines = lines,
            modified = true,
        })
    end)
end

function M.create_copy_store_entry()
    local mode = vim.fn.mode()
    local lines

    if mode == "v" or mode == "V" or mode == "\22" then
        vim.cmd('normal! "vy')
        local raw = vim.fn.getreg("v")
        lines = vim.split(raw, "\n", { plain = true })
    else
        lines = {}
    end

    local targets = save_target_dirs()
    if #targets == 1 then
        return new_copy_name_flow(targets[1].dir, lines)
    end

    vim.ui.select(targets, {
        prompt = "Save in:",
        format_item = function(t)
            return t.label
        end,
    }, function(choice)
        if choice == nil then
            return
        end
        new_copy_name_flow(choice.dir, lines)
    end)
end

local function open_editor_for_item(item)
    local path = Snacks.picker.util.path(item)
    if not path then
        return
    end
    local name = vim.fn.fnamemodify(path, ":t")
    open_editor_float({
        title = " Edit: " .. name .. " ",
        path = path,
    })
end

function M.edit_copy_store_entry()
    local items = list_copy_items()
    if #items == 0 then
        vim.notify("No copies yet", vim.log.levels.INFO)
        return
    end

    Snacks.picker.pick({
        source = "copy_store_edit",
        items = items,
        format = "file",
        formatters = { file = { filename_only = true } },
        title = "Edit Copy",
        -- prompt = "Edit Copy> ",
        confirm = function(picker, item)
            picker:close()
            if item then
                open_editor_for_item(item)
            end
        end,
    })
end

function M.edit_cwd_entry()
    Snacks.picker.files({
        -- prompt = "Edit from CWD> ",
        cwd = vim.fn.getcwd(),
        ft = { "md", "txt" },
        confirm = function(picker, item)
            picker:close()
            if item then
                open_editor_for_item(item)
            end
        end,
    })
end

-- Captures the paste target BEFORE the picker opens (mode, cursor, selection).
local function capture_paste_ctx()
    local mode = vim.fn.mode()
    local is_visual = mode == "v" or mode == "V" or mode == "\22"
    local buf = vim.api.nvim_get_current_buf()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local sel_start, sel_end
    if is_visual then
        -- leave visual mode so '< '> marks are set
        vim.cmd("normal! \27")
        sel_start = vim.api.nvim_buf_get_mark(buf, "<")[1]
        sel_end = vim.api.nvim_buf_get_mark(buf, ">")[1]
    end
    return {
        buf = buf,
        cursor_line = cursor_line,
        is_visual = is_visual,
        sel_start = sel_start,
        sel_end = sel_end,
    }
end

-- Reads each absolute path, joins with blank lines + a leading blank line, and
-- inserts below the cursor (or replaces the selection) using the captured ctx.
local function paste_paths(paths, ctx)
    local combined = {}
    for i, path in ipairs(paths) do
        if i > 1 then
            table.insert(combined, "")
        end
        for _, line in ipairs(vim.fn.readfile(path)) do
            table.insert(combined, line)
        end
    end
    table.insert(combined, 1, "")

    if ctx.is_visual then
        vim.api.nvim_buf_set_lines(ctx.buf, ctx.sel_start - 1, ctx.sel_end, false, combined)
    else
        vim.api.nvim_buf_set_lines(ctx.buf, ctx.cursor_line, ctx.cursor_line, false, combined)
    end
end

function M.paste_copy_store_entry()
    local ctx = capture_paste_ctx()

    local items = list_copy_items()
    if #items == 0 then
        vim.notify("No copies yet", vim.log.levels.INFO)
        return
    end

    Snacks.picker.pick({
        source = "copy_store_paste",
        items = items,
        format = "file",
        -- formatters = { file = { filename_only = true } },
        title = "Paste Copy",
        -- prompt = "Paste Copy> ",
        confirm = function(picker)
            local selected = picker:selected({ fallback = true })
            picker:close()
            local paths = {}
            for _, item in ipairs(selected) do
                table.insert(paths, Snacks.picker.util.path(item))
            end
            paste_paths(paths, ctx)
        end,
    })
end

function M.paste_cwd_entry()
    local ctx = capture_paste_ctx()

    Snacks.picker.files({
        -- prompt = "Paste from CWD> ",
        cwd = vim.fn.getcwd(),
        ft = { "md", "txt" },
        confirm = function(picker)
            local selected = picker:selected({ fallback = true })
            picker:close()
            local paths = {}
            for _, item in ipairs(selected) do
                table.insert(paths, Snacks.picker.util.path(item))
            end
            paste_paths(paths, ctx)
        end,
    })
end

return M
