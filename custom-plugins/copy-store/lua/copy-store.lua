local M = {}

local state = { extra_dirs = {} }

function M.setup(opts)
    opts = opts or {}
    state.extra_dirs = opts.extra_dirs or {}
end

local function copies_dir()
    return vim.fn.stdpath("config") .. "/custom-plugins/copy-store/copies"
end

local function ensure_dir(dir)
    vim.fn.mkdir(dir, "p")
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

-- fzf entries gathered recursively from every source dir, as tab-joined
-- "<filename  (label)>\t<absolute-path>" strings. Field 1 is shown; field 2
-- (the path) is recovered in actions/preview.
local function list_copy_entries()
    local entries = {}
    for _, src in ipairs(source_dirs()) do
        for _, path in ipairs(vim.fn.globpath(src.dir, "**/*", false, true)) do
            if vim.fn.isdirectory(path) == 0 then
                local display = vim.fn.fnamemodify(path, ":t") .. "  (" .. src.label .. ")"
                table.insert(entries, display .. "\t" .. path)
            end
        end
    end
    table.sort(entries)
    return entries
end

local function entry_path(entry)
    return entry:match("\t(.+)$") or entry
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

local function write_file(dir, name, lines)
    ensure_dir(dir)
    vim.fn.writefile(lines, dir .. "/" .. name)
end

-- Opens a centered float seeded with `lines`. On ZZ/:wq runs the save-flow
-- (choose dir, then name); on ZX/:q/<localleader>x discards. `orig_path` (or
-- nil for a new copy) is the file being edited, used to default the dir/name,
-- allow overwriting itself, and delete the original on move/rename.
local function open_editor_float(opts)
    local lines = opts.lines or {}
    local orig_path = opts.orig_path
    local orig_dir = orig_path and vim.fn.fnamemodify(orig_path, ":h") or nil
    local orig_name = orig_path and vim.fn.fnamemodify(orig_path, ":t") or nil

    local win = Snacks.win({
        title = opts.title or " Copy Store ",
        title_pos = "center",
        width = 0.8,
        height = 0.8,
        border = "rounded",
        enter = true,
        ft = "markdown",
        wo = { number = true, relativenumber = false, wrap = true },
        bo = { modifiable = true, buftype = "acwrite" },
    })

    local buf = win.buf
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modified = false
    vim.api.nvim_buf_set_name(buf, "copy-store://" .. (orig_name or "new"))

    local closed = false
    local function close()
        if closed then
            return
        end
        closed = true
        win:close()
    end

    -- Prompt for a name in `dir`, then write. Re-prompts on invalid/colliding
    -- name. When editing and the typed name is unchanged, the original name is
    -- kept verbatim (no sanitize); otherwise the name is sanitized. On a path
    -- change (different dir and/or name) the original file is deleted (move).
    local function name_flow(dir, default)
        vim.ui.input({ prompt = "Save copy as: ", default = default }, function(input)
            if input == nil then
                return
            end
            local name
            if orig_name and vim.trim(input) == orig_name then
                name = orig_name
            else
                name = sanitize_name(input)
                if not name then
                    vim.notify("Invalid name", vim.log.levels.ERROR)
                    return name_flow(dir, default)
                end
            end
            local new_path = vim.fn.fnamemodify(dir .. "/" .. name, ":p")
            local same_as_orig = orig_path ~= nil and new_path == vim.fn.fnamemodify(orig_path, ":p")
            if file_exists(dir, name) and not same_as_orig then
                vim.notify("'" .. name .. "' already exists, choose another name", vim.log.levels.ERROR)
                return name_flow(dir, name)
            end
            local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            write_file(dir, name, content)
            if orig_path and not same_as_orig then
                vim.fn.delete(orig_path)
            end
            vim.bo[buf].modified = false
            vim.notify("Saved " .. name, vim.log.levels.INFO)
            close()
        end)
    end

    -- Choose target dir (skip the picker when there's only one), then name.
    -- When editing, the file's current dir is listed first, marked "(current)".
    local function do_save()
        local targets = save_target_dirs()
        if orig_dir then
            for i, t in ipairs(targets) do
                if vim.fn.fnamemodify(t.dir, ":p") == vim.fn.fnamemodify(orig_dir, ":p") then
                    t.label = t.label .. " (current)"
                    table.insert(targets, 1, table.remove(targets, i))
                    break
                end
            end
        end

        if #targets == 1 then
            return name_flow(targets[1].dir, orig_name)
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
            name_flow(choice.dir, orig_name)
        end)
    end

    -- :w / :wq / :x / ZZ route through the save logic (acwrite => no real write).
    local saving = false
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        callback = function()
            saving = true
            do_save()
        end,
    })

    -- :q / ZX / <localleader>x discard. QuitPre fires before :q closes the win.
    -- For :wq the BufWriteCmd above runs first and sets `saving`, so the
    -- following QuitPre is skipped and the save-flow controls the close.
    vim.api.nvim_create_autocmd("QuitPre", {
        buffer = buf,
        callback = function()
            if saving then
                saving = false
                return
            end
            close()
        end,
    })

    local map_opts = { buffer = buf, silent = true, nowait = true }
    vim.keymap.set("n", "ZZ", do_save, map_opts)
    vim.keymap.set("n", "ZX", close, map_opts)
    vim.keymap.set("n", "<localleader>x", close, map_opts)
end

function M.create_copy_store_entry()
    local mode = vim.fn.mode()
    local lines

    if mode == "v" or mode == "V" or mode == "\22" then
        vim.cmd('normal! "vy')
        local raw = vim.fn.getreg("v")
        lines = vim.split(raw, "\n", { plain = true })
    else
        lines = { vim.api.nvim_get_current_line() }
    end

    open_editor_float({
        title = " New Copy ",
        lines = lines,
        orig_path = nil,
    })
end

local function copy_preview()
    return {
        type = "cmd",
        field_index = "{}",
        fn = function(items)
            return "cat " .. vim.fn.shellescape(entry_path(items[1]))
        end,
    }
end

function M.edit_copy_store_entry()
    local entries = list_copy_entries()
    if #entries == 0 then
        vim.notify("No copies yet", vim.log.levels.INFO)
        return
    end

    require("fzf-lua").fzf_exec(entries, {
        prompt = "Edit Copy> ",
        preview = copy_preview(),
        fzf_opts = { ["--delimiter"] = "\t", ["--with-nth"] = "1", ["--nth"] = "1" },
        actions = {
            ["default"] = function(selected)
                if not selected or #selected == 0 then
                    return
                end
                local path = entry_path(selected[1])
                local name = vim.fn.fnamemodify(path, ":t")
                local content = vim.fn.readfile(path)
                open_editor_float({
                    title = " Edit: " .. name .. " ",
                    lines = content,
                    orig_path = path,
                })
            end,
        },
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

    local entries = list_copy_entries()
    if #entries == 0 then
        vim.notify("No copies yet", vim.log.levels.INFO)
        return
    end

    require("fzf-lua").fzf_exec(entries, {
        prompt = "Paste Copy> ",
        preview = copy_preview(),
        fzf_opts = { ["--multi"] = true, ["--delimiter"] = "\t", ["--with-nth"] = "1", ["--nth"] = "1" },
        actions = {
            ["default"] = function(selected)
                if not selected or #selected == 0 then
                    return
                end
                local paths = {}
                for _, entry in ipairs(selected) do
                    table.insert(paths, entry_path(entry))
                end
                paste_paths(paths, ctx)
            end,
        },
    })
end

function M.paste_cwd_entry()
    local ctx = capture_paste_ctx()

    require("fzf-lua").files({
        prompt = "Paste from CWD> ",
        cwd = vim.fn.getcwd(),
        cmd = "fd --type f -e md -e txt",
        fzf_opts = { ["--multi"] = true },
        actions = {
            ["default"] = function(selected, opts)
                if not selected or #selected == 0 then
                    return
                end
                local fzf_path = require("fzf-lua.path")
                local paths = {}
                for _, entry in ipairs(selected) do
                    table.insert(paths, fzf_path.entry_to_file(entry, opts).path)
                end
                paste_paths(paths, ctx)
            end,
        },
    })
end

return M
