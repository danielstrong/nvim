-- Repo-wide git hunk navigation: jump to next/prev hunk across the whole
-- repository (staged + unstaged + untracked), crossing file boundaries.
local M = {}

M.wrap = true

local function git(args, cwd)
    local res = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
    if res.code ~= 0 then
        return nil
    end
    return res.stdout or ""
end

local function repo_root()
    local out = git({ "rev-parse", "--show-toplevel" })
    if not out then
        return nil
    end
    out = vim.trim(out)
    return out ~= "" and out or nil
end

local function parse_diff(out, root, hunks)
    local file
    for line in vim.gsplit(out or "", "\n", { plain = true }) do
        local f = line:match("^%+%+%+ b/(.+)$")
        if f then
            file = (f == "/dev/null") and nil or (root .. "/" .. f)
        elseif line:match("^%+%+%+ /dev/null") then
            file = nil
        elseif file then
            local start, count = line:match("^@@ %-%d+,?%d* %+(%d+),?(%d*) @@")
            if start then
                start = tonumber(start)
                count = tonumber(count) or 1
                local lnum = (count == 0) and math.max(start, 1) or start
                hunks[#hunks + 1] = { file = file, lnum = lnum }
            end
        end
    end
end

local function collect_hunks()
    local root = repo_root()
    if not root then
        return nil
    end

    local hunks = {}

    -- Tracked changes (staged + unstaged) vs HEAD. Fall back to plain diff
    -- when there are no commits yet (HEAD is invalid).
    local diff = git({ "--no-pager", "diff", "-U0", "HEAD" }, root)
    if not diff then
        diff = git({ "--no-pager", "diff", "-U0" }, root)
    end
    parse_diff(diff, root, hunks)

    -- Untracked files: synthesize a single hunk at line 1.
    local untracked = git({ "ls-files", "--others", "--exclude-standard" }, root)
    for line in vim.gsplit(untracked or "", "\n", { plain = true }) do
        if line ~= "" then
            hunks[#hunks + 1] = { file = root .. "/" .. line, lnum = 1 }
        end
    end

    table.sort(hunks, function(a, b)
        if a.file ~= b.file then
            return a.file < b.file
        end
        return a.lnum < b.lnum
    end)

    return hunks, root
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

local function is_after(h, cur)
    if h.file ~= cur.file then
        return h.file > cur.file
    end
    return h.lnum > cur.lnum
end

local function goto_hunk(target)
    local cur = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
    if cur ~= target.file then
        vim.cmd("edit " .. vim.fn.fnameescape(target.file))
    end
    local lnum = math.min(target.lnum, vim.api.nvim_buf_line_count(0))
    vim.api.nvim_win_set_cursor(0, { math.max(lnum, 1), 0 })
    vim.cmd("normal! zz")
end

local function navigate(forward)
    local hunks = collect_hunks()
    if hunks == nil then
        vim.notify("Not a git repository", vim.log.levels.WARN)
        return
    end
    if #hunks == 0 then
        vim.notify("No git hunks in repository", vim.log.levels.INFO)
        return
    end

    local cur = current_pos()
    local target

    if not cur then
        target = forward and hunks[1] or hunks[#hunks]
    elseif forward then
        for _, h in ipairs(hunks) do
            if is_after(h, cur) then
                target = h
                break
            end
        end
        if not target then
            target = M.wrap and hunks[1] or nil
        end
    else
        for i = #hunks, 1, -1 do
            local h = hunks[i]
            if not is_after(h, cur) and not (h.file == cur.file and h.lnum == cur.lnum) then
                target = h
                break
            end
        end
        if not target then
            target = M.wrap and hunks[#hunks] or nil
        end
    end

    if target then
        goto_hunk(target)
    end
end

function M.next()
    navigate(true)
end

function M.prev()
    navigate(false)
end

return M
