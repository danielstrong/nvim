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

local function toggle_view(key, open)
    local tabpage = tracked[key]
    if tabpage and vim.api.nvim_tabpage_is_valid(tabpage) and require("diffview.lib").tabpage_to_view(tabpage) then
        if vim.api.nvim_get_current_tabpage() == tabpage then
            tracked[key] = nil
            vim.cmd("DiffviewClose")
        else
            vim.api.nvim_set_current_tabpage(tabpage)
        end
        return
    end

    tracked[key] = nil
    open()

    local view = require("diffview.lib").get_current_view()
    if view then
        tracked[key] = view.tabpage
    end
end

local function open_file_diff(...)
    local cursor = vim.api.nvim_win_get_cursor(0)
    pending_cursor = { path = vim.api.nvim_buf_get_name(0), line = cursor[1], col = cursor[2] }
    vim.cmd("DiffviewOpen " .. table.concat({ ... }, " "))
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
                    toggle_view("open", function()
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

            -- Toggle diff for the current file only (Diffview alternative to <localleader>gd)
            {
                "<localleader>od",
                function()
                    local path = target_path()
                    toggle_view("file:" .. path, function()
                        open_file_diff("--", vim.fn.fnameescape(path))
                    end)
                end,
                mode = "n",
                desc = "Toggle file diff (Diffview)",
            },

            -- Toggle diff for the current file against the last commit (Diffview alternative to <localleader>gD)
            {
                "<localleader>oD",
                function()
                    local path = target_path()
                    toggle_view("file@HEAD~1:" .. path, function()
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
                    toggle_view("history:" .. path, function()
                        vim.cmd("DiffviewFileHistory " .. vim.fn.fnameescape(path))
                    end)
                end,
                mode = "n",
                desc = "File history (current file)",
            },
            {
                "<localleader>oH",
                function()
                    toggle_view("history:@repo", function()
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
                    toggle_view("line-history:" .. target_path(), function()
                        vim.cmd(line .. "DiffviewFileHistory --follow")
                    end)
                end,
                mode = "n",
                desc = "Line history",
            },

            -- Diff against main/master branch (useful before merging)
            {
                "<localleader>om",
                function()
                    -- Try main first, fall back to master
                    local result = vim.fn.systemlist({ "git", "rev-parse", "--verify", "main" })
                    local ok = vim.v.shell_error == 0 and result[1] ~= nil and result[1] ~= ""
                    local branch = ok and "main" or "master"
                    toggle_view("branch:" .. branch, function()
                        vim.cmd("DiffviewOpen " .. branch)
                    end)
                end,
                mode = "n",
                desc = "Diff against main/master",
            },
        },
        opts = {
            enhanced_diff_hl = true,
            use_icons = true,
            view = {
                default = { layout = "diff1_inline" },
                file_history = { layout = "diff1_inline" },
                merge_tool = { layout = "diff3_horizontal" },
                cycle_layouts = {
                    default = { "diff1_inline", "diff2_horizontal" },
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
                file_panel = {
                    { "n", "<localleader>e", toggle_panel_focus, { desc = "Toggle file panel focus" } },
                },
                file_history_panel = {
                    { "n", "<localleader>e", toggle_panel_focus, { desc = "Toggle file panel focus" } },
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
                "<localleader>gu",
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
