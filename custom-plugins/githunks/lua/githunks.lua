-- Repo-wide git hunk navigation: jump to next/prev hunk across the whole
-- repository (staged + unstaged + untracked), crossing file boundaries.
local M = {}

M.wrap = true
-- When true, compare-branch hunks diff against the remote-tracking ref
-- (e.g. origin/main). When false, prefer the local branch of the same name
-- (e.g. main) if it exists, falling back to the remote-tracking ref.
M.prefer_remote_tracking = true

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

local function collect_hunks(unstaged_only)
    local root = repo_root()
    if not root then
        return nil
    end

    local hunks = {}

    local diff
    if unstaged_only then
        -- Working tree vs index: unstaged changes only.
        diff = git({ "--no-pager", "diff", "-U0" }, root)
    else
        -- Tracked changes (staged + unstaged) vs HEAD. Fall back to plain diff
        -- when there are no commits yet (HEAD is invalid).
        diff = git({ "--no-pager", "diff", "-U0", "HEAD" }, root)
        if not diff then
            diff = git({ "--no-pager", "diff", "-U0" }, root)
        end
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

local function branch_exists_locally(name, root)
    return git({ "show-ref", "--verify", "--quiet", "refs/heads/" .. name }, root) ~= nil
end

-- Resolves the default branch to diff against: origin/HEAD's target if a
-- remote is configured (honoring M.prefer_remote_tracking), else a local
-- main/master branch. Returns the ref to diff against and to display, e.g.
-- "origin/main" or "main".
local function resolve_default_branch(root)
    local symref = git({ "symbolic-ref", "refs/remotes/origin/HEAD" }, root)
    if symref then
        local name = vim.trim(symref):match("^refs/remotes/origin/(.+)$")
        if name then
            local remote_ref = "origin/" .. name
            if M.prefer_remote_tracking then
                return remote_ref
            end
            if branch_exists_locally(name, root) then
                return name
            end
            return remote_ref
        end
    end

    for _, name in ipairs({ "main", "master" }) do
        if branch_exists_locally(name, root) then
            return name
        end
    end

    return nil
end

local function current_branch_display(root)
    local name = git({ "rev-parse", "--abbrev-ref", "HEAD" }, root)
    if name then
        name = vim.trim(name)
        if name ~= "HEAD" and name ~= "" then
            return name
        end
    end
    local sha = git({ "rev-parse", "--short", "HEAD" }, root)
    return sha and vim.trim(sha) or "HEAD"
end

-- Hunks between the merge-base of HEAD and the default branch, and the
-- current working tree (so uncommitted changes are included).
local function collect_comparebranch_hunks()
    local root = repo_root()
    if not root then
        vim.notify("Not a git repository", vim.log.levels.WARN)
        return nil
    end

    local default_ref = resolve_default_branch(root)
    if not default_ref then
        vim.notify("Could not determine default branch", vim.log.levels.WARN)
        return nil
    end

    local merge_base = git({ "merge-base", default_ref, "HEAD" }, root)
    if not merge_base then
        vim.notify("Could not determine default branch", vim.log.levels.WARN)
        return nil
    end
    merge_base = vim.trim(merge_base)

    local hunks = {}
    parse_diff(git({ "--no-pager", "diff", "-U0", merge_base }, root), root, hunks)

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

    return hunks, default_ref, merge_base
end

-- Keeps Gitsigns' diff base (used for its gutter signs) in sync with the
-- mode being navigated. Sentinel-based cache avoids re-diffing every
-- attached buffer on every hop when repeatedly navigating the same mode.
local GITSIGNS_BASE_UNSET = {}
local last_gitsigns_base = GITSIGNS_BASE_UNSET

local function sync_gitsigns_base(base)
    if last_gitsigns_base ~= GITSIGNS_BASE_UNSET and last_gitsigns_base == base then
        return
    end
    require("gitsigns").change_base(base, true)
    last_gitsigns_base = base
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

local function select_target(hunks, direction)
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

    return target, idx, forward
end

local function navigate(direction, unstaged_only)
    local base_label = unstaged_only and "index" or "HEAD"
    if unstaged_only then
        sync_gitsigns_base(nil)
    else
        sync_gitsigns_base("HEAD")
    end

    local hunks = collect_hunks(unstaged_only)
    if hunks == nil then
        vim.notify("Not a git repository", vim.log.levels.WARN)
        return
    end
    if #hunks == 0 then
        vim.notify("No git hunks in repository", vim.log.levels.INFO)
        return
    end

    local target, idx, forward = select_target(hunks, direction)

    if target then
        local line = forward and target.lnum or target.endln
        goto_hunk(target, line)
        vim.notify(string.format("Hunk %d of %d (%s...)", idx, #hunks, base_label), vim.log.levels.INFO)
    end
end

local function navigate_comparebranch(direction)
    local hunks, default_ref, merge_base = collect_comparebranch_hunks()
    if hunks == nil then
        return
    end
    sync_gitsigns_base(merge_base)

    if #hunks == 0 then
        vim.notify(string.format("No hunks comparing %s to HEAD", default_ref), vim.log.levels.INFO)
        return
    end

    local target, idx, forward = select_target(hunks, direction)

    if target then
        local line = forward and target.lnum or target.endln
        goto_hunk(target, line)
        local current_branch = current_branch_display(repo_root())
        vim.notify(string.format("Hunk %d of %d (%s...%s)", idx, #hunks, default_ref, current_branch), vim.log.levels.INFO)
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

function M.next_unstaged()
    navigate("next", true)
end

function M.prev_unstaged()
    navigate("prev", true)
end

function M.first_unstaged()
    navigate("first", true)
end

function M.last_unstaged()
    navigate("last", true)
end

function M.next_comparebranch()
    navigate_comparebranch("next")
end

function M.prev_comparebranch()
    navigate_comparebranch("prev")
end

function M.first_comparebranch()
    navigate_comparebranch("first")
end

function M.last_comparebranch()
    navigate_comparebranch("last")
end

function M.setup()
    vim.notify("githunks setup being called..")
end

return M
