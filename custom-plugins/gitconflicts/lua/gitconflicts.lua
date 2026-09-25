-- Repo-wide conflict-marker navigation: jump to Git conflict marker lines
-- across the whole repository, crossing file boundaries. Uses ripgrep, which
-- skips gitignored files by default.
local M = {}

M.wrap = true

local function repo_root()
    local res = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
    if res.code ~= 0 then
        return nil
    end
    local out = vim.trim(res.stdout or "")
    return out ~= "" and out or nil
end

local function collect_marks(root)
    if vim.fn.executable("rg") == 0 then
        vim.notify("ripgrep (rg) not found in PATH", vim.log.levels.ERROR)
        return nil
    end

    local res = vim
        .system(
            { "rg", "--line-number", "--no-heading", "--with-filename", "-e", "^<<<<<<< ", "-e", "^=======$", "-e", "^>>>>>>> " },
            { cwd = root, text = true }
        )
        :wait()
    -- rg exits 1 (not an error) when there are simply no matches
    if res.code > 1 then
        vim.notify("ripgrep failed while searching for conflict markers", vim.log.levels.ERROR)
        return nil
    end

    local marks = {}
    for line in vim.gsplit(res.stdout or "", "\n", { plain = true }) do
        local file, lnum = line:match("^(.-):(%d+):")
        if file then
            marks[#marks + 1] = { file = root .. "/" .. file, lnum = tonumber(lnum) }
        end
    end

    table.sort(marks, function(a, b)
        if a.file ~= b.file then
            return a.file < b.file
        end
        return a.lnum < b.lnum
    end)

    return marks
end

local function current_pos()
    if vim.bo.buftype ~= "" then
        return nil
    end
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return nil
    end
    return {
        file = vim.fn.fnamemodify(name, ":p"),
        lnum = vim.api.nvim_win_get_cursor(0)[1],
    }
end

local function goto_mark(target)
    local cur = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
    if cur ~= target.file then
        vim.cmd("edit " .. vim.fn.fnameescape(target.file))
    end
    local line = math.min(target.lnum, vim.api.nvim_buf_line_count(0))
    vim.api.nvim_win_set_cursor(0, { math.max(line, 1), 0 })
    vim.cmd("normal! zz")
end

local function select_target(marks, direction)
    if direction == "first" then
        return marks[1], 1
    end
    if direction == "last" then
        return marks[#marks], #marks
    end

    local forward = direction == "next"
    local cur = current_pos()
    if not cur then
        local idx = forward and 1 or #marks
        return marks[idx], idx
    end

    if forward then
        for i, m in ipairs(marks) do
            if m.file > cur.file or (m.file == cur.file and m.lnum > cur.lnum) then
                return m, i
            end
        end
        if M.wrap then
            return marks[1], 1
        end
    else
        for i = #marks, 1, -1 do
            local m = marks[i]
            if m.file < cur.file or (m.file == cur.file and m.lnum < cur.lnum) then
                return m, i
            end
        end
        if M.wrap then
            return marks[#marks], #marks
        end
    end
end

local function navigate(direction)
    local root = repo_root()
    if not root then
        vim.notify("Not a git repository", vim.log.levels.WARN)
        return
    end

    local marks = collect_marks(root)
    if marks == nil then
        return
    end
    if #marks == 0 then
        vim.notify("No conflict markers in repository", vim.log.levels.INFO)
        return
    end

    local target, idx = select_target(marks, direction)
    if target then
        goto_mark(target)
        vim.notify(string.format("Conflict marker %d of %d", idx, #marks), vim.log.levels.INFO)
    end
end

function M.next()
    navigate("next")
end

function M.prev()
    navigate("prev")
end

function M.first()
    navigate("first")
end

function M.last()
    navigate("last")
end

return M
