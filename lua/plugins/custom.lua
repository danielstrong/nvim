return {
    {
        "custom/copy-store",
        dev = true,
        dependencies = { "folke/snacks.nvim" },
        opts = {
            -- Extra absolute dirs (~ allowed) that act as full copy stores:
            -- they're listed for paste/edit and offered as save targets, so
            -- copies can be created and renamed in them just like the nvim
            -- copies/ dir. Example: extra_dirs = { "~/my-prompts" }
            extra_dirs = vim.g.is_mac and {
                "~/.config/clp",
            } or nil,
        },
        keys = {
            {
                "<localleader>jn",
                function()
                    require("copy-store").create_copy_store_entry()
                end,
                mode = { "n", "x" },
                desc = "Create New Copy for Copy Store",
            },
            {
                "<localleader>jo",
                function()
                    require("copy-store").edit_copy_store_entry()
                end,
                mode = { "n", "x" },
                desc = "Modify Copy from Copy Store",
            },
            {
                "<localleader>jp",
                function()
                    require("copy-store").paste_copy_store_entry()
                end,
                mode = { "n", "x" },
                desc = "Paste Copy from Copy Store",
            },
            {
                "<localleader>jP",
                function()
                    require("copy-store").paste_cwd_entry()
                end,
                mode = { "n", "x" },
                desc = "Paste Copy from CWD",
            },
            {
                "<localleader>jO",
                function()
                    require("copy-store").edit_cwd_entry()
                end,
                mode = { "n", "x" },
                desc = "Modify Copy from CWD",
            },
            {
                "<localleader>j#",
                ":<C-u>g/^#/d<CR>",
                mode = { "n" },
                desc = "Delete lines starting with #",
            },
        },
    },
    {
        "custom/window-move",
        dev = true,
        keys = {
            {
                "<localleader>wmk",
                function()
                    require("window-move").window_move("up")
                end,
                mode = { "n", "x" },
                desc = "Move Window Up",
            },
            {
                "<localleader>wmj",
                function()
                    require("window-move").window_move("down")
                end,
                mode = { "n", "x" },
                desc = "Move Window Down",
            },
            {
                "<localleader>wmh",
                function()
                    require("window-move").window_move("left")
                end,
                mode = { "n", "x" },
                desc = "Move Window Left",
            },
            {
                "<localleader>wml",
                function()
                    require("window-move").window_move("right")
                end,
                mode = { "n", "x" },
                desc = "Move Window Right",
            },
        },
    },
    {
        "custom/project-check",
        dev = true,
        keys = {
            {
                "<localleader>kj",
                function()
                    require("project-check").run_checks(true)
                end,
                desc = "TSC + ESLint to Quickfix",
            },
            {
                "<localleader>kJ",
                function()
                    require("project-check").run_checks(false)
                end,
                desc = "TSC + ESLint to Quickfix (include warnings)",
            },
            {
                "<localleader>kl",
                function()
                    require("project-check").view_project_check_logs()
                end,
                desc = "View Project Check logs",
            },
        },
    },
    {
        "custom/githunks",
        event = "LazyFile",
        dev = true,
        dependencies = {
            {
                -- dep because my config uses repeatable-move
                "kiyoon/repeatable-move.nvim",
                dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
            },
        },
        keys = function()
            local gh = require("githunks")
            local repeat_move = require("repeatable_move")
            local repeatable_next_basehunk, repeatable_prev_basehunk = repeat_move.make_repeatable_move_pair(gh.next_base, gh.prev_base)
            local repeatable_next_allhunk, repeatable_prev_allhunk = repeat_move.make_repeatable_move_pair(gh.next, gh.prev)

            return {
                { "]g", repeatable_next_basehunk, mode = { "n", "x", "o" }, desc = "Next Hunk vs base (repo-wide)" },
                { "[g", repeatable_prev_basehunk, mode = { "n", "x", "o" }, desc = "Prev Hunk vs base (repo-wide)" },
                { "]G", gh.last_base, mode = { "n", "x", "o" }, desc = "Last Hunk vs base (repo-wide)" },
                { "[G", gh.first_base, mode = { "n", "x", "o" }, desc = "First Hunk vs base (repo-wide)" },
                { "]y", repeatable_next_allhunk, mode = { "n", "x", "o" }, desc = "Next Hunk vs HEAD (repo-wide)" },
                { "[y", repeatable_prev_allhunk, mode = { "n", "x", "o" }, desc = "Prev Hunk vs HEAD (repo-wide)" },
                { "]Y", gh.last, mode = { "n", "x", "o" }, desc = "Last Hunk vs HEAD (repo-wide)" },
                { "[Y", gh.first, mode = { "n", "x", "o" }, desc = "First Hunk vs HEAD (repo-wide)" },
                -- ●/○ mark the active base (Index at startup); githunks rewrites these on change
                { "ghai", gh.set_index, desc = "● Index" },
                { "ghaH", gh.set_head, desc = "○ HEAD" },
                { "gha1", function() gh.set_head_n(1) end, desc = "○ HEAD~1" },
                { "gha2", function() gh.set_head_n(2) end, desc = "○ HEAD~2" },
                { "gha3", function() gh.set_head_n(3) end, desc = "○ HEAD~3" },
                { "gha4", function() gh.set_head_n(4) end, desc = "○ HEAD~4" },
                { "gha5", function() gh.set_head_n(5) end, desc = "○ HEAD~5" },
                { "gham", gh.set_mb_default, desc = "○ Merge-base with default branch" },
                { "ghaM", gh.set_tip_default, desc = "○ Default branch tip" },
                { "ghab", gh.pick_mb_branch, desc = "○ Branch (merge-base)…" },
                { "ghaB", gh.pick_tip_branch, desc = "○ Branch (tip)…" },
                { "ghac", gh.pick_commit, desc = "○ Commit…" },
            }
        end,
    },
    {
        "custom/gitconflicts",
        event = "LazyFile",
        dev = true,
        dependencies = {
            {
                -- dep because my config uses repeatable-move
                "kiyoon/repeatable-move.nvim",
                dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
            },
        },
        keys = function()
            local gc = require("gitconflicts")
            local repeat_move = require("repeatable_move")
            local repeatable_next_conflict, repeatable_prev_conflict = repeat_move.make_repeatable_move_pair(gc.next, gc.prev)

            return {
                { "]n", repeatable_next_conflict, mode = { "n", "x", "o" }, desc = "Next Conflict Marker (repo-wide)" },
                { "[n", repeatable_prev_conflict, mode = { "n", "x", "o" }, desc = "Prev Conflict Marker (repo-wide)" },
                { "]N", gc.last, mode = { "n", "x", "o" }, desc = "Last Conflict Marker (repo-wide)" },
                { "[N", gc.first, mode = { "n", "x", "o" }, desc = "First Conflict Marker (repo-wide)" },
            }
        end,
    },
}
