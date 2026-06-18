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
                local endln = (count == 0) and lnum or (start + count - 1)
                hunks[#hunks + 1] = { file = file, lnum = lnum, endln = endln }
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
            hunks[#hunks + 1] = { file = root .. "/" .. line, lnum = 1, endln = 1 }
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

local function is_before(h, cur)
    if h.file ~= cur.file then
        return h.file < cur.file
    end
    return h.endln < cur.lnum
end

local function goto_hunk(target, line)
    local cur = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
    if cur ~= target.file then
        vim.cmd("edit " .. vim.fn.fnameescape(target.file))
    end
    line = math.min(line, vim.api.nvim_buf_line_count(0))
    vim.api.nvim_win_set_cursor(0, { math.max(line, 1), 0 })
    vim.cmd("normal! zz")
end

local function navigate(direction)
    local hunks = collect_hunks()
    if hunks == nil then
        vim.notify("Not a git repository", vim.log.levels.WARN)
        return
    end
    if #hunks == 0 then
        vim.notify("No git hunks in repository", vim.log.levels.INFO)
        return
    end

    local forward = direction == "next" or direction == "last"
    local target, idx

    if direction == "first" then
        target, idx = hunks[1], 1
    elseif direction == "last" then
        target, idx = hunks[#hunks], #hunks
    else
        local cur = current_pos()
        if not cur then
            idx = forward and 1 or #hunks
            target = hunks[idx]
        elseif forward then
            for i, h in ipairs(hunks) do
                if is_after(h, cur) then
                    target, idx = h, i
                    break
                end
            end
            if not target and M.wrap then
                target, idx = hunks[1], 1
            end
        else
            for i = #hunks, 1, -1 do
                if is_before(hunks[i], cur) then
                    target, idx = hunks[i], i
                    break
                end
            end
            if not target and M.wrap then
                target, idx = hunks[#hunks], #hunks
            end
        end
    end

    if target then
        local line = forward and target.lnum or target.endln
        goto_hunk(target, line)
        vim.notify(string.format("Hunk %d of %d", idx, #hunks), vim.log.levels.INFO)
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

function M.setup()
    vim.notify("githunks setup being called..")
end

return M
