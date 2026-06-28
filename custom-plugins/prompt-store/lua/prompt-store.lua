local M = {}

local function prompts_dir()
    return vim.fn.stdpath("config") .. "/custom-plugins/prompt-store/prompts"
end

local function ensure_dir()
    vim.fn.mkdir(prompts_dir(), "p")
end

local function list_prompt_files()
    local dir = prompts_dir()
    if vim.fn.isdirectory(dir) == 0 then
        return {}
    end
    local names = {}
    for _, path in ipairs(vim.fn.globpath(dir, "*", false, true)) do
        if vim.fn.isdirectory(path) == 0 then
            table.insert(names, vim.fn.fnamemodify(path, ":t"))
        end
    end
    table.sort(names)
    return names
end

local function file_exists(name)
    return vim.fn.filereadable(prompts_dir() .. "/" .. name) == 1
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
    base = base:gsub("[^%w%-]", "")
    base = base:gsub("%-+", "-")
    base = base:gsub("^%-+", ""):gsub("%-+$", "")
    if base == "" then
        return nil
    end
    return base .. "." .. ext
end

local function write_file(name, lines)
    ensure_dir()
    vim.fn.writefile(lines, prompts_dir() .. "/" .. name)
end

-- Opens a centered float seeded with `lines`. On ZZ/:wq runs the save-flow;
-- on ZX/:q/<localleader>x discards. `self_name` (or nil) is the file being
-- edited so the collision check can allow overwriting it.
local function open_editor_float(opts)
    local lines = opts.lines or {}
    local self_name = opts.self_name
    local default_name = opts.default_name

    local win = Snacks.win({
        title = opts.title or " Prompt Store ",
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
    vim.api.nvim_buf_set_name(buf, "prompt-store://" .. (self_name or "new"))

    local closed = false
    local function close()
        if closed then
            return
        end
        closed = true
        win:close()
    end

    local function save_flow(default)
        vim.ui.input({ prompt = "Save prompt as: ", default = default }, function(input)
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

    -- :w / :wq / :x / ZZ route through the save-flow (acwrite => no real write).
    local saving = false
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        callback = function()
            saving = true
            save_flow(default_name)
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
    vim.keymap.set("n", "ZZ", function()
        save_flow(default_name)
    end, map_opts)
    vim.keymap.set("n", "ZX", close, map_opts)
    vim.keymap.set("n", "<localleader>x", close, map_opts)
end

function M.create_prompt_store_entry()
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
        title = " New Prompt ",
        lines = lines,
        self_name = nil,
        default_name = nil,
    })
end

function M.edit_prompt_store_entry()
    local files = list_prompt_files()
    if #files == 0 then
        vim.notify("No prompts yet", vim.log.levels.INFO)
        return
    end

    require("fzf-lua").fzf_exec(files, {
        prompt = "Edit Prompt> ",
        actions = {
            ["default"] = function(selected)
                if not selected or #selected == 0 then
                    return
                end
                local name = selected[1]
                local content = vim.fn.readfile(prompts_dir() .. "/" .. name)
                open_editor_float({
                    title = " Edit: " .. name .. " ",
                    lines = content,
                    self_name = name,
                    default_name = name,
                })
            end,
        },
    })
end

function M.paste_prompt_store_entry()
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

    local files = list_prompt_files()
    if #files == 0 then
        vim.notify("No prompts yet", vim.log.levels.INFO)
        return
    end

    require("fzf-lua").fzf_exec(files, {
        prompt = "Paste Prompt> ",
        fzf_opts = { ["--multi"] = true },
        actions = {
            ["default"] = function(selected)
                if not selected or #selected == 0 then
                    return
                end
                local combined = {}
                for i, name in ipairs(selected) do
                    if i > 1 then
                        table.insert(combined, "")
                    end
                    for _, line in ipairs(vim.fn.readfile(prompts_dir() .. "/" .. name)) do
                        table.insert(combined, line)
                    end
                end

                if is_visual then
                    vim.api.nvim_buf_set_lines(buf, sel_start - 1, sel_end, false, combined)
                else
                    vim.api.nvim_buf_set_lines(buf, cursor_line, cursor_line, false, combined)
                end
            end,
        },
    })
end

return M
