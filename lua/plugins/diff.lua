-- Remembers where the cursor was in the file being diffed so the "new state"
-- (working tree) buffer can be restored to that position instead of landing
-- on line 1 when Diffview opens.
local pending_cursor = nil

local function toggle_panel_focus()
    local view = require("diffview.lib").get_current_view()
    if not view then
        return
    end
    if view.panel:is_focused() then
        local main = view.cur_layout and view.cur_layout:get_main_win()
        if main and main:is_valid() then
            main:focus()
        end
    else
        require("diffview.actions").focus_files()
    end
end

-- Maps a logical view key (what a mapping asks for) to the tabpage holding it,
-- so the same mapping can close the view when focused, or jump to its tab when
-- it lives elsewhere. Diffview only dedupes `DiffviewOpen`, never file history.
local tracked = {}

-- The file a mapping should act on. Inside a Diffview tab the current buffer may
-- be a panel or a `diffview://` revision buffer, so ask the view for its current
-- entry instead — otherwise the key can never match the one used to open it.
local function target_path()
    local view = require("diffview.lib").get_current_view()
    if view then
        local entry
        if type(view.cur_file) == "function" then
            entry = view:cur_file()
        end
        entry = entry or view.cur_entry or (view.panel and view.panel.cur_file)
        if entry and entry.absolute_path then
            return entry.absolute_path
        end
    end
    return vim.fn.expand("%:p")
end

-- Jumps to the view tracked under `key` when it is still alive, else opens it.
local function open_view(kind, key, open)
    local lib = require("diffview.lib")

    local tabpage = tracked[key]
    if tabpage and vim.api.nvim_tabpage_is_valid(tabpage) and lib.tabpage_to_view(tabpage) then
        vim.api.nvim_set_current_tabpage(tabpage)
        return
    end

    tracked[key] = nil
    open()

    local view = lib.get_current_view()
    if view then
        tracked[key] = view.tabpage
        vim.t[view.tabpage].diffview_toggle_kind = kind
        vim.t[view.tabpage].diffview_toggle_key = key
    end
end

-- `kind` identifies the mapping, `key` the specific view it wants. Closing keys
-- off `kind` recorded on the tabpage, not off `key`: a diff of a file with no
-- changes has an empty file list, so `target_path()` cannot rebuild the `key`
-- the tab was opened with and the view could never be closed from inside it.
local function toggle_view(kind, key, open)
    local lib = require("diffview.lib")
    local cur = vim.api.nvim_get_current_tabpage()

    if lib.tabpage_to_view(cur) and vim.t[cur].diffview_toggle_kind == kind then
        tracked[vim.t[cur].diffview_toggle_key] = nil
        vim.cmd("DiffviewClose")
        return
    end

    open_view(kind, key, open)
end

-- Opens a diff of the working tree against `ref`. The kind is per-ref so that
-- switching bases jumps between tabs instead of closing the one in view.
local function open_branch_diff(ref, jump_only)
    local kind = "branch:" .. ref
    local open = function()
        vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(ref))
    end
    if jump_only then
        open_view(kind, kind, open)
    else
        toggle_view(kind, kind, open)
    end
end

-- Only the newest scheduled follow runs; earlier ones see a stale token.
local follow_token = 0

-- Open the entry under the file panel cursor in the main window as the cursor
-- moves, without stealing focus from the panel.
--
-- Debounced so holding `j` loads only the entry the cursor settles on. Each
-- `set_file` starts async buffer loads, and diffview toggles the *global*
-- `eventignore` while attaching a file, so overlapping loads can swallow a
-- buffer's FileType event and leave it with no syntax highlighting.
local function follow_panel_cursor()
    follow_token = follow_token + 1
    local token = follow_token

    vim.defer_fn(function()
        if token ~= follow_token then
            return
        end

        local view = require("diffview.lib").get_current_view()
        if not view or not view.panel or not view.panel:is_focused() then
            return
        end

        local item = view.panel:get_item_at_cursor()
        -- Directory nodes in the tree listing carry a `collapsed` field.
        if not item or type(item.collapsed) == "boolean" or item == view.panel.cur_file then
            return
        end

        view:set_file(item, false)
    end, 80)
end

-- Scrolls the main diff window from a panel without moving focus. `distance` is
-- a fraction of the window height; whole numbers are read as a line count.
local function scroll_diff(distance)
    return function()
        require("diffview.actions").scroll_view(distance)()
    end
end

-- Line-precise counterpart to `scroll_diff`, negative for up. Not routed through
-- `scroll_view`: that formats whole-number distances straight into `norm!`, so a
-- negative count runs a leading `-` as a motion and moves the cursor too.
local function scroll_diff_lines(lines)
    return function()
        local view = require("diffview.lib").get_current_view()
        local main = view and view.cur_layout and view.cur_layout:get_main_win()
        if not main or not main:is_valid() then
            return
        end
        local keys = math.abs(lines) .. vim.keycode(lines < 0 and "<C-y>" or "<C-e>")
        vim.api.nvim_win_call(main.id, function()
            vim.cmd("normal! " .. keys)
        end)
    end
end

local function open_file_diff(...)
    local cursor = vim.api.nvim_win_get_cursor(0)
    pending_cursor = { path = vim.api.nvim_buf_get_name(0), line = cursor[1], col = cursor[2] }
    vim.cmd("DiffviewOpen " .. table.concat({ ... }, " "))
end

local function act(name, arg)
    return function()
        local action = require("diffview.actions")[name]
        if arg then
            action = action(arg)
        end
        return action()
    end
end

-- Edit `lhs` to rebind; `default` is diffview's built-in key, which gets disabled
-- when it differs from `lhs`. `panel = true` also binds it in the file panel.
local conflict_keymaps = {
    -- { default = "[x", lhs = "[x", action = act("prev_conflict"), desc = "Jump to the previous conflict marker", panel = true },
    -- { default = "]x", lhs = "]x", action = act("next_conflict"), desc = "Jump to the next conflict marker", panel = true },
    { default = "<leader>co", lhs = "gho", action = act("conflict_choose", "ours"), desc = "Choose the OURS version of a conflict" },
    { default = "<leader>ct", lhs = "ght", action = act("conflict_choose", "theirs"), desc = "Choose the THEIRS version of a conflict" },
    { default = "<leader>cb", lhs = "ghb", action = act("conflict_choose", "base"), desc = "Choose the BASE version of a conflict" },
    { default = "<leader>ca", lhs = "gha", action = act("conflict_choose", "all"), desc = "Choose all the versions of a conflict" },
    { default = "dx", lhs = "ghx", action = act("conflict_choose", "none"), desc = "Delete the conflict region" },
    { default = "<leader>cO", lhs = "ghO", action = act("conflict_choose_all", "ours"), desc = "Choose the OURS version of a conflict for the whole file", panel = true },
    { default = "<leader>cT", lhs = "ghT", action = act("conflict_choose_all", "theirs"), desc = "Choose the THEIRS version of a conflict for the whole file", panel = true },
    { default = "<leader>cB", lhs = "ghB", action = act("conflict_choose_all", "base"), desc = "Choose the BASE version of a conflict for the whole file", panel = true },
    { default = "<leader>cA", lhs = "ghA", action = act("conflict_choose_all", "all"), desc = "Choose all the versions of a conflict for the whole file", panel = true },
    { default = "dX", lhs = "ghX", action = act("conflict_choose_all", "none"), desc = "Delete the conflict region for the whole file", panel = true },
    { default = "<leader>cso", lhs = "ghmo", action = act("conflict_choose_side", "ours"), desc = "Replace the MERGED buffer with the entire OURS side" },
    { default = "<leader>cst", lhs = "ghmt", action = act("conflict_choose_side", "theirs"), desc = "Replace the MERGED buffer with the entire THEIRS side" },
    { default = "<leader>csb", lhs = "ghmb", action = act("conflict_choose_side", "base"), desc = "Replace the MERGED buffer with the entire BASE side" },
}

local function build_conflict_keymaps(panel_only)
    local maps = {}
    for _, m in ipairs(conflict_keymaps) do
        if not panel_only or m.panel then
            if m.default ~= m.lhs then
                table.insert(maps, { "n", m.default, false })
            end
            table.insert(maps, { "n", m.lhs, m.action, { desc = m.desc } })
        end
    end
    return maps
end

return {

    {
        "dlyongemallo/diffview-plus.nvim",
        version = "*",
        -- optional: lazy-load on command
        -- cmd = {
        --     "DiffviewOpen",
        --     "DiffviewToggle",
        --     "DiffviewFileHistory",
        --     "DiffviewDiffFiles",
        --     "DiffviewLog",
        -- },
        keys = {
            {
                "<localleader>oo",
                function()
                    toggle_view("open", "open", function()
                        vim.cmd("DiffviewOpen")
                    end)
                end,
                mode = "n",
                desc = "Toggle Diffview",
            },
            { "<localleader>oO", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
            {
                "<localleader>oe",
                toggle_panel_focus,
                mode = "n",
                desc = "Toggle file panel focus",
            },
            { "<localleader>oE", "<cmd>DiffviewToggleFiles<cr>", mode = "n", desc = "Toggle file panel" },
            { "<localleader>ox", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },

            -- Toggle diff for the current file only
            {
                "<localleader>od",
                function()
                    local path = target_path()
                    toggle_view("file", "file:" .. path, function()
                        open_file_diff("--", vim.fn.fnameescape(path))
                    end)
                end,
                mode = "n",
                desc = "Toggle file diff (Diffview)",
            },

            -- Toggle diff for the current file against the last commit
            {
                "<localleader>oD",
                function()
                    local path = target_path()
                    toggle_view("file@HEAD~1", "file@HEAD~1:" .. path, function()
                        open_file_diff("HEAD~1", "--", vim.fn.fnameescape(path))
                    end)
                end,
                mode = "n",
                desc = "Toggle file diff against last commit (Diffview)",
            },

            -- File history
            {
                "<localleader>oh",
                function()
                    local path = target_path()
                    toggle_view("history", "history:" .. path, function()
                        vim.cmd("DiffviewFileHistory " .. vim.fn.fnameescape(path))
                    end)
                end,
                mode = "n",
                desc = "File history (current file)",
            },
            {
                "<localleader>oH",
                function()
                    toggle_view("history@repo", "history:@repo", function()
                        vim.cmd("DiffviewFileHistory")
                    end)
                end,
                mode = "n",
                desc = "File history (repo)",
            },

            -- Visual mode: history for selection
            {
                "<localleader>oh",
                "<Esc><cmd>'<,'>DiffviewFileHistory --follow<CR>",
                mode = "x",
                desc = "Range history",
            },

            -- Single line history
            {
                "<localleader>ol",
                function()
                    local line = vim.api.nvim_win_get_cursor(0)[1]
                    -- Keyed by file, not line: a line-history tab is reachable
                    -- (and closable) from the same file regardless of cursor row.
                    toggle_view("line-history", "line-history:" .. target_path(), function()
                        vim.cmd(line .. "DiffviewFileHistory --follow")
                    end)
                end,
                mode = "n",
                desc = "Line history",
            },

            -- Diff against the repo's default branch (useful before merging)
            {
                "<localleader>om",
                function()
                    local ref = require("githunks").resolve_default_branch()
                    if not ref then
                        vim.notify("Could not determine default branch", vim.log.levels.WARN)
                        return
                    end
                    open_branch_diff(ref)
                end,
                mode = "n",
                desc = "Diff against default branch",
            },

            -- Diff against a branch chosen from a picker
            {
                "<localleader>oM",
                function()
                    Snacks.picker.git_branches({
                        all = true,
                        confirm = function(picker, item)
                            picker:close()
                            local ref = item and (item.branch or item.commit)
                            if not ref then
                                return
                            end
                            -- `git branch --all` lists remote-tracking refs as
                            -- `remotes/origin/x`; the stripped form reads better
                            -- in the Diffview title and resolves the same.
                            open_branch_diff((ref:gsub("^remotes/", "")), true)
                        end,
                    })
                end,
                mode = "n",
                desc = "Diff against branch (picker)",
            },
        },
        opts = {
            enhanced_diff_hl = true,
            diffopt = { algorithm = "histogram" },
            use_icons = true,
            clean_up_buffers = true,
            view = {
                default = { layout = "diff1_inline" },
                file_history = { layout = "diff1_inline" },
                merge_tool = { layout = "diff3_mixed" },
                cycle_layouts = {
                    default = { "diff1_inline", "diff2_horizontal", "diff1_plain" },
                    file_history = { "diff1_inline", "diff2_horizontal", "diff1_plain" },
                    merge_tool = { "diff3_horizontal", "diff3_mixed", "diff4_mixed", "diff1_plain" },
                },
            },
            file_panel = {
                listing_style = "tree",
                win_config = { position = "left", width = 35 }, -- Use "auto" to fit content
                show = true,
            },
            file_history_panel = {
                win_config = { position = "left", width = 60 },
            },
            hooks = {
                -- Diffview's panel and `diffview://` buffers are unlisted, so
                -- mini.clue's own BufWinEnter autocmd skips them and never
                -- attaches the <localleader>/<leader> trigger keymaps that
                -- pop up the clue window. Attach them ourselves.
                view_opened = function(view)
                    local bufnr = view.panel and view.panel.bufid
                    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
                        return
                    end
                    require("custom-utils.clue_triggers").ensure(bufnr)
                    if vim.bo[bufnr].filetype ~= "DiffviewFiles" then
                        return
                    end
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        group = vim.api.nvim_create_augroup("diffview_follow_cursor_" .. bufnr, { clear = true }),
                        buffer = bufnr,
                        callback = follow_panel_cursor,
                    })
                end,
                diff_buf_read = function(bufnr)
                    require("custom-utils.clue_triggers").ensure(bufnr)
                end,
                -- Restore cursor position in the working-tree ("b") buffer
                -- when it matches the file we opened the diff from.
                diff_buf_win_enter = function(bufnr, winid, ctx)
                    if not pending_cursor or ctx.symbol ~= "b" then
                        return
                    end
                    if vim.api.nvim_buf_get_name(bufnr) ~= pending_cursor.path then
                        return
                    end
                    local line = math.min(pending_cursor.line, vim.api.nvim_buf_line_count(bufnr))
                    pcall(vim.api.nvim_win_set_cursor, winid, { line, pending_cursor.col })
                    pending_cursor = nil
                end,
            }, -- See :h diffview-config-hooks
            keymaps = {
                -- `view` keymaps are merged into every layout's maps
                view = {
                    {
                        "n",
                        "<localleader>oi",
                        function()
                            require("diffview.actions").cycle_layout()
                        end,
                        { desc = "Toggle inline / side-by-side diff" },
                    },
                    { "n", "<localleader>e", toggle_panel_focus, { desc = "Toggle file panel focus" } },
                },
                diff1 = build_conflict_keymaps(),
                diff3 = build_conflict_keymaps(),
                diff4 = build_conflict_keymaps(),
                file_panel = vim.list_extend({
                    { "n", "<localleader>e", toggle_panel_focus, { desc = "Toggle file panel focus" } },
                    { "n", "f", scroll_diff(0.25), { desc = "Scroll the diff view down" } },
                    { "n", "b", scroll_diff(-0.25), { desc = "Scroll the diff view up" } },
                    { "n", "e", scroll_diff_lines(1), { desc = "Scroll the diff view down one line" } },
                    { "n", "r", scroll_diff_lines(-1), { desc = "Scroll the diff view up one line" } },
                    -- Default `f`, displaced by the scroll mapping above.
                    {
                        "n",
                        "zf",
                        function()
                            require("diffview.actions").toggle_flatten_dirs()
                        end,
                        { desc = "Flatten empty subdirectories in tree listing style" },
                    },
                }, build_conflict_keymaps(true)),
                file_history_panel = {
                    { "n", "<localleader>e", toggle_panel_focus, { desc = "Toggle file panel focus" } },
                    { "n", "f", scroll_diff(0.25), { desc = "Scroll the diff view down" } },
                    { "n", "b", scroll_diff(-0.25), { desc = "Scroll the diff view up" } },
                    { "n", "e", scroll_diff_lines(1), { desc = "Scroll the diff view down one line" } },
                    { "n", "r", scroll_diff_lines(-1), { desc = "Scroll the diff view up one line" } },
                },
            }, -- See :h diffview-config-keymaps
            -- keymaps = {
            --     view = {
            --         -- Use localleader instead to avoid conflicts
            --         { "n", "<localleader>e", require("diffview.actions").focus_files },
            --         { "n", "<localleader>b", require("diffview.actions").toggle_files },
            --         -- Or disable specific mappings
            --         { "n", "<leader>e", false },
            --     },
            -- },
        },
    },
    {
        enabled = true,
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            -- "dlyongemallo/diffview-plus.nvim",
            -- "m00qek/baleia.nvim", -- optional, for custom log pager
            -- "folke/snacks.nvim",
        },
        cmd = "Neogit",
        opts = {
            integrations = {
                diffview = true,
                snacks = true,
            },
            diff_viewer = "diffview",
        },
        keys = {
            {
                "<localleader>ou",
                function()
                    local neogit = require("neogit")
                    if require("neogit.buffers.status").is_open() then
                        neogit.close()
                    else
                        neogit.open()
                    end
                end,
                desc = "Toggle Neogit UI",
            },
        },
    },
}
