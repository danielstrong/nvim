-- Repo-wide git hunk navigation: jump to next/prev hunk across the whole
-- repository, crossing file boundaries. Also owns the global Gitsigns diff
-- base (what the gutter, [h/]h and ]g/[g compare against).
local M = {}

M.wrap = true
-- When true, default-branch bases use the remote-tracking ref (e.g.
-- origin/main). When false, prefer the local branch of the same name (e.g.
-- main) if it exists, falling back to the remote-tracking ref.
M.prefer_remote_tracking = true

M.prefix = "gha"

---@class githunks.Base
---@field kind string
---@field ref? string passed to gitsigns.change_base; nil means the index
---@field label? string shown in the ruler; nil when comparing against the index
---@field detail? string shown next to the active entry in the clue popup

---@type githunks.Base
M.base = { kind = "index" }

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

-- ref == nil diffs the working tree against the index (unstaged changes only).
local function collect_hunks(ref)
    local root = repo_root()
    if not root then
        return nil
    end

    local hunks = {}

    local diff
    if ref == nil then
        diff = git({ "--no-pager", "diff", "-U0" }, root)
    else
        diff = git({ "--no-pager", "diff", "-U0", ref }, root)
        -- HEAD is invalid in a repo with no commits yet.
        if not diff and ref == "HEAD" then
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
function M.resolve_default_branch(root)
    root = root or repo_root()
    if not root then
        return nil
    end

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

local function navigate(direction, ref, label)
    local hunks = collect_hunks(ref)
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
        local suffix = label and (" (vs " .. label .. ")") or ""
        vim.notify(string.format("Hunk %d of %d%s", idx, #hunks, suffix), vim.log.levels.INFO)
    end
end

-- Always staged + unstaged vs HEAD, regardless of the global base.
function M.next()
    navigate("next", "HEAD")
end

function M.prev()
    navigate("prev", "HEAD")
end

function M.first()
    navigate("first", "HEAD")
end

function M.last()
    navigate("last", "HEAD")
end

-- Follows the global base, i.e. a repo-wide ]h.
function M.next_base()
    navigate("next", M.base.ref, M.base.label)
end

function M.prev_base()
    navigate("prev", M.base.ref, M.base.label)
end

function M.first_base()
    navigate("first", M.base.ref, M.base.label)
end

function M.last_base()
    navigate("last", M.base.ref, M.base.label)
end

---------------------------------------------------------------------------
-- Global diff base
---------------------------------------------------------------------------

-- nerd font "nf-dev-git_branch" (U+E725)
M.icon = "\238\156\165"

-- Ruler segment; empty when comparing against the index.
function M.status()
    if not M.base.label then
        return ""
    end
    return " " .. M.icon .. " " .. M.base.label
end

local function short(sha)
    return sha:sub(1, 7)
end

local entries -- defined below; referenced by refresh_descs

local function refresh_descs()
    local ok, miniclue = pcall(require, "mini.clue")
    if not ok then
        return
    end
    for _, e in ipairs(entries) do
        local active = e.kind == M.base.kind
        local desc = (active and "● " or "○ ") .. e.name
        if active and M.base.detail then
            desc = desc .. " (" .. M.base.detail .. ")"
        end
        pcall(miniclue.set_mapping_desc, "n", M.prefix .. e.lhs, desc)
    end
end

---@param base githunks.Base
local function apply(base)
    M.base = base
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        gitsigns.change_base(base.ref, true)
    end
    refresh_descs()
    local shown = base.label or "Index"
    if base.detail then
        shown = shown .. " (" .. base.detail .. ")"
    end
    vim.notify("Hunk base: " .. shown, vim.log.levels.INFO, { title = "githunks" })
    vim.cmd.redrawstatus()
end

local function require_root()
    local root = repo_root()
    if not root then
        vim.notify("Not a git repository", vim.log.levels.WARN)
    end
    return root
end

local function merge_base(ref, root)
    local out = git({ "merge-base", ref, "HEAD" }, root)
    if not out then
        vim.notify("Could not determine merge-base of " .. ref .. " and HEAD", vim.log.levels.WARN)
        return nil
    end
    return vim.trim(out)
end

local function default_branch_or_warn(root)
    local ref = M.resolve_default_branch(root)
    if not ref then
        vim.notify("Could not determine default branch", vim.log.levels.WARN)
    end
    return ref
end

local function set_merge_base(kind, ref, root)
    local sha = merge_base(ref, root)
    if sha then
        apply({ kind = kind, ref = sha, label = "mb:" .. ref, detail = ref .. " @ " .. short(sha) })
    end
end

-- `git branch --all` lists remote-tracking refs as `remotes/origin/x`.
local function pick_branch(on_ref)
    Snacks.picker.git_branches({
        all = true,
        confirm = function(picker, item)
            picker:close()
            local ref = item and (item.branch or item.commit)
            if ref then
                on_ref((ref:gsub("^remotes/", "")))
            end
        end,
    })
end

function M.set_index()
    apply({ kind = "index" })
end

function M.set_head()
    apply({ kind = "head", ref = "HEAD", label = "HEAD" })
end

function M.set_head_n(n)
    local ref = "HEAD~" .. n
    apply({ kind = "head" .. n, ref = ref, label = ref })
end

function M.set_mb_default()
    local root = require_root()
    local ref = root and default_branch_or_warn(root)
    if ref then
        set_merge_base("mb_default", ref, root)
    end
end

function M.set_tip_default()
    local root = require_root()
    local ref = root and default_branch_or_warn(root)
    if ref then
        apply({ kind = "tip_default", ref = ref, label = ref, detail = ref })
    end
end

function M.pick_mb_branch()
    local root = require_root()
    if not root then
        return
    end
    pick_branch(function(ref)
        set_merge_base("mb_branch", ref, root)
    end)
end

function M.pick_tip_branch()
    if not require_root() then
        return
    end
    pick_branch(function(ref)
        apply({ kind = "tip_branch", ref = ref, label = ref, detail = ref })
    end)
end

function M.pick_commit()
    local root = require_root()
    if not root then
        return
    end
    Snacks.picker.git_log({
        confirm = function(picker, item)
            picker:close()
            local commit = item and item.commit
            if not commit then
                return
            end
            local sha = vim.trim(git({ "rev-parse", commit }, root) or commit)
            apply({ kind = "commit", ref = sha, label = short(sha), detail = short(sha) })
        end,
    })
end

-- lhs suffixes must match the gha* keys in lua/plugins/custom.lua
entries = {
    { lhs = "i", kind = "index", name = "Index" },
    { lhs = "H", kind = "head", name = "HEAD" },
    { lhs = "1", kind = "head1", name = "HEAD~1" },
    { lhs = "2", kind = "head2", name = "HEAD~2" },
    { lhs = "3", kind = "head3", name = "HEAD~3" },
    { lhs = "4", kind = "head4", name = "HEAD~4" },
    { lhs = "5", kind = "head5", name = "HEAD~5" },
    { lhs = "m", kind = "mb_default", name = "Merge-base with default branch" },
    { lhs = "M", kind = "tip_default", name = "Default branch tip" },
    { lhs = "b", kind = "mb_branch", name = "Branch (merge-base)…" },
    { lhs = "B", kind = "tip_branch", name = "Branch (tip)…" },
    { lhs = "c", kind = "commit", name = "Commit…" },
}

return M
