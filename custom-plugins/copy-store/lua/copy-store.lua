local M = {}

local state = { extra_dirs = {} }

function M.setup(opts)
    opts = opts or {}
    state.extra_dirs = opts.extra_dirs or {}
end

local function copies_dir()
    return vim.fn.stdpath("config") .. "/custom-plugins/copy-store/copies"
end

local function ensure_dir()
    vim.fn.mkdir(copies_dir(), "p")
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

-- Absolute path of copies_dir(), normalized, with a trailing slash.
local function copies_root()
    return vim.fn.fnamemodify(copies_dir(), ":p")
end

local function is_in_copies(path)
    local full = vim.fn.fnamemodify(path, ":p")
    return full:sub(1, #copies_root()) == copies_root()
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

local function file_exists(name)
    return vim.fn.filereadable(copies_dir() .. "/" .. name) == 1
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

local function write_file(name, lines)
    ensure_dir()
    vim.fn.writefile(lines, copies_dir() .. "/" .. name)
end

-- Opens a centered float seeded with `lines`. On ZZ/:wq runs the save-flow;
-- on ZX/:q/<localleader>x discards. `self_name` (or nil) is the file being
-- edited so the collision check can allow overwriting it.
local function open_editor_float(opts)
    local lines = opts.lines or {}
    local self_name = opts.self_name
    local default_name = opts.default_name
    -- When set and outside copies_dir(), saving writes here in place (no prompt).
    local save_path = opts.save_path
    local in_place = save_path ~= nil and not is_in_copies(save_path)

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
    vim.api.nvim_buf_set_name(buf, "copy-store://" .. (self_name or "new"))

    local closed = false
    local function close()
        if closed then
            return
        end
        closed = true
        win:close()
    end

    -- In-place save for extra-dir files: write straight to save_path, no prompt.
    local function save_in_place()
        local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        vim.fn.writefile(content, save_path)
        vim.bo[buf].modified = false
        vim.notify("Saved " .. vim.fn.fnamemodify(save_path, ":t"), vim.log.levels.INFO)
        close()
    end

    -- Name-prompt save for new copies and files inside copies_dir().
    local function save_flow(default)
        vim.ui.input({ prompt = "Save copy as: ", default = default }, function(input)
            if input == nil then
                return
            end
            local name = sanitize_name(input)
            if not name then
                vim.notify("Invalid name", vim.log.levels.ERROR)
                return save_flow(default)
            end
            if file_exists(name) and name ~= self_name then
                vim.notify("'" .. name .. "' already exists, choose another name", vim.log.levels.ERROR)
                return save_flow(name)
            end
            local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            write_file(name, content)
            vim.bo[buf].modified = false
            vim.notify("Saved " .. name, vim.log.levels.INFO)
            close()
        end)
    end

    local function do_save()
        if in_place then
            save_in_place()
        else
            save_flow(default_name)
        end
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
        self_name = nil,
        default_name = nil,
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
                if is_in_copies(path) then
                    open_editor_float({
                        title = " Edit: " .. name .. " ",
                        lines = content,
                        self_name = name,
                        default_name = name,
                    })
                else
                    open_editor_float({
                        title = " Edit: " .. name .. " ",
                        lines = content,
                        save_path = path,
                    })
                end
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
