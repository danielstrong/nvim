local M = {}

local function find_zdiff_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "zdiff" then
            return win, buf
        end
    end
end

---@return string|nil path absolute path of the current file
---@return number|nil lnum cursor line
local function source_position()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype ~= "" then
        return
    end
    local path = vim.api.nvim_buf_get_name(buf)
    if path == "" then
        return
    end
    return path, vim.api.nvim_win_get_cursor(0)[1]
end

---@param path string absolute path
---@param files ZdiffFile[]
---@return number|nil index into files
local function file_index(path, files)
    for idx, file in ipairs(files) do
        local rel = file.new_path or file.path
        if rel and path:sub(-#rel - 1) == "/" .. rel then
            return idx
        end
    end
end

---Find the zdiff buffer line showing `lnum` of `path`, closest match wins.
---@param ctx table zdiff render context
---@param path string absolute path
---@param lnum number line in the source file
---@return number|nil
local function zdiff_line_for(ctx, path, lnum)
    if not ctx.files or not ctx.line_map then
        return
    end
    local idx = file_index(path, ctx.files)
    if not idx then
        return
    end

    local file = ctx.files[idx]
    if file.expanded and file.hunk_status ~= "loaded" then
        return
    end

    local best, best_distance
    for line, map in pairs(ctx.line_map) do
        if map.file_idx == idx and map.lnum and map.hunk_idx and map.line_idx then
            local hunk = file.hunks[map.hunk_idx]
            local diff_line = hunk and hunk.lines[map.line_idx]
            -- deleted lines carry an old-side lnum, a different coordinate space
            if diff_line and diff_line.type ~= "del" then
                local distance = math.abs(map.lnum - lnum)
                if not best_distance or distance < best_distance then
                    best, best_distance = line, distance
                end
            end
        end
    end

    return best or ctx.file_header_lines[idx]
end

local function zdiff_idle()
    local ok, debug_state = pcall(function()
        return require("zdiff")._debug_state()
    end)
    if not ok then
        return true
    end
    return not debug_state.loading_files
        and not debug_state.pending_render
        and debug_state.pending_hunk_jobs == 0
        and debug_state.pending_syntax_jobs == 0
end

---@class ZdiffFollow
---@field path string absolute path of the file to land on
---@field lnum number line in that file to land on
---@field deadline number uv timestamp after which the request is abandoned
---@field view_row number|nil screen row the target line is pinned to

---@type ZdiffFollow|nil
local follow
local applying = false
local on_key_ns = vim.api.nvim_create_namespace("zdiff_follow_source")

local function stop_following()
    follow = nil
    -- deferred so this is safe to call from inside the on_key callback itself
    vim.schedule(function()
        if not follow then
            vim.on_key(nil, on_key_ns)
        end
    end)
end

---Put the cursor on the requested source line, in the same tick as the render
---that produced `ctx`. zdiff rebuilds the buffer several times while diffs load
---asynchronously, and each rebuild clamps the cursor back to the top; correcting
---it here rather than from a timer keeps the jump off the screen.
---@param ctx table zdiff render context
local function apply_follow(ctx)
    if not follow or applying then
        return
    end
    if (vim.uv or vim.loop).now() > follow.deadline then
        return stop_following()
    end

    local win, buf = find_zdiff_win()
    if not win or not buf then
        return
    end

    local target = zdiff_line_for(ctx, follow.path, follow.lnum)
    if not target or target > vim.api.nvim_buf_line_count(buf) then
        return
    end

    if vim.api.nvim_win_get_cursor(win)[1] ~= target then
        -- Centre on the first placement, then keep the target line on the same
        -- screen row: later renders shift it as other files' diffs stream in, and
        -- re-centring every time is what makes the window look like it jumps.
        local height = vim.api.nvim_win_get_height(win)
        follow.view_row = follow.view_row or math.min(target, math.floor(height / 2) + 1)
        local topline = math.max(1, target - follow.view_row + 1)

        applying = true
        -- winrestview instead of `normal! zz`, which would trip the on_key guard
        vim.api.nvim_win_call(win, function()
            vim.fn.winrestview({ lnum = target, col = 0, topline = topline })
        end)
        applying = false
    end

    if zdiff_idle() then
        stop_following()
    end
end

-- zdiff keeps its render state private; the winbar hook it calls at the end of
-- every render is the only place it hands out the buffer line map.
local hooked = false

local function hook_renders()
    if hooked then
        return
    end
    hooked = true
    local winbar = require("zdiff.winbar")
    local update = winbar.update
    winbar.update = function(ctx, win)
        apply_follow(ctx)
        return update(ctx, win)
    end
end

---@param path string absolute path
---@param lnum number line in the source file
local function follow_source(path, lnum)
    follow = {
        path = path,
        lnum = lnum,
        deadline = (vim.uv or vim.loop).now() + 5000,
    }
    vim.on_key(function()
        if follow then
            stop_following()
        end
    end, on_key_ns)
end

local git_patched = false
-- Whether the open session wants the worktree compared against the index.
local unstaged_session = false
-- Whether the mode currently being loaded is that unstaged one. zdiff routes
-- every mode change through a `diff` call before it loads any file content, so
-- the target seen there is authoritative for the `show` calls that follow.
local unstaged_mode = false

---Rewrite a zdiff git invocation so its no-base-ref mode diffs the worktree
---against the index instead of HEAD, hiding changes that are already staged.
---@param args string[] argv after `git -C <root>`
---@return string[]
local function rewrite_git_args(args)
    if args[1] == "diff" then
        -- zdiff puts the diff target after its options and before any `--`
        for i = 2, #args do
            local arg = args[i]
            if arg == "--" then
                break
            elseif arg == "HEAD" then
                unstaged_mode = unstaged_session
                if unstaged_mode then
                    args = vim.deepcopy(args)
                    table.remove(args, i)
                end
                return args
            elseif arg == "--cached" or arg:find("...", 1, true) then
                unstaged_mode = false
                return args
            end
        end
    elseif args[1] == "show" and unstaged_mode and args[2] then
        -- the old side of the diff is the index now, not the last commit
        local path = args[2]:match("^HEAD:(.*)$")
        if path then
            args = vim.deepcopy(args)
            args[2] = ":" .. path
        end
    end
    return args
end

local function patch_git()
    if git_patched then
        return
    end
    git_patched = true
    local git = require("zdiff.git")
    for _, name in ipairs({ "run_lines", "run_async" }) do
        local original = git[name]
        git[name] = function(root, args, ...)
            return original(root, rewrite_git_args(args), ...)
        end
    end
end

---Open zdiff, or close it if it is already showing in a window.
---@param base_ref? string git ref to diff against. nil compares against HEAD.
---@param opts? {unstaged?: boolean} compare the worktree against the index instead
function M.toggle(base_ref, opts)
    local zdiff = require("zdiff")
    local _, buf = find_zdiff_win()
    if not buf then
        hook_renders()
        patch_git()
        unstaged_session = (opts or {}).unstaged == true
        local path, lnum = source_position()
        if path and lnum then
            follow_source(path, lnum)
        end
        zdiff.open(base_ref)
        return
    end

    -- zdiff's close() is private; its buffer-local close key is the only handle on it
    local lhs = zdiff.config.keymaps.close
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
        if map.lhs == lhs and map.callback then
            map.callback()
            return
        end
    end
end

return M
