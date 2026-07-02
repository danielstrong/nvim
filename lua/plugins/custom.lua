return {
    {
        "custom/copy-store",
        dev = true,
        dependencies = { "ibhagwan/fzf-lua" },
        opts = {
            -- Extra absolute dirs (~ allowed) that act as full copy stores:
            -- they're listed for paste/edit and offered as save targets, so
            -- copies can be created and renamed in them just like the nvim
            -- copies/ dir. Example: extra_dirs = { "~/my-prompts" }
            extra_dirs = vim.g.is_mac and {
                "~/.claude/custom-system-prompts",
                "~/.config/clp/context",
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
                "<localleader>ds",
                function()
                    require("project-check").run_checks(true)
                end,
                desc = "TSC + ESLint to Quickfix",
            },
            {
                "<localleader>dS",
                function()
                    require("project-check").run_checks(false)
                end,
                desc = "TSC + ESLint to Quickfix (include warnings)",
            },
            {
                "<localleader>nl",
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
            local repeatable_next_unstagedhunk, repeatable_prev_unstagedhunk = repeat_move.make_repeatable_move_pair(gh.next_unstaged, gh.prev_unstaged)
            -- vim.keymap.set({ "n", "x", "o" }, "]g", repeatable_next_unstagedhunk, { desc = "Next Unstaged Hunk (repo-wide)" })
            -- vim.keymap.set({ "n", "x", "o" }, "[g", repeatable_prev_unstagedhunk, { desc = "Prev Unstaged Hunk (repo-wide)" })
            -- vim.keymap.set({ "n", "x", "o" }, "]G", gh.last_unstaged, { desc = "Last Unstaged Hunk (repo-wide)" })
            -- vim.keymap.set({ "n", "x", "o" }, "[G", gh.first_unstaged, { desc = "First Unstaged Hunk (repo-wide)" })
            --
            local repeatable_next_allhunk, repeatable_prev_allhunk = repeat_move.make_repeatable_move_pair(gh.next, gh.prev)
            -- vim.keymap.set({ "n", "x", "o" }, "]y", repeatable_next_allhunk, { desc = "Next Hunk (repo-wide)" })
            -- vim.keymap.set({ "n", "x", "o" }, "[y", repeatable_prev_allhunk, { desc = "Prev Hunk (repo-wide)" })
            -- vim.keymap.set({ "n", "x", "o" }, "]Y", gh.last, { desc = "Last Hunk (repo-wide)" })
            -- vim.keymap.set({ "n", "x", "o" }, "[Y", gh.first, { desc = "First Hunk (repo-wide)" })
            return {
                { "]g", repeatable_next_unstagedhunk, mode = { "n", "x", "o" }, desc = "Next Unstaged Hunk (repo-wide)" },
                { "[g", repeatable_prev_unstagedhunk, mode = { "n", "x", "o" }, desc = "Prev Unstaged Hunk (repo-wide)" },
                { "]G", gh.last_unstaged, mode = { "n", "x", "o" }, desc = "Last Unstaged Hunk (repo-wide)" },
                { "[G", gh.first_unstaged, mode = { "n", "x", "o" }, desc = "First Unstaged Hunk (repo-wide)" },
                { "]y", repeatable_next_allhunk, mode = { "n", "x", "o" }, desc = "Next Hunk (repo-wide)" },
                { "[y", repeatable_prev_allhunk, mode = { "n", "x", "o" }, desc = "Prev Hunk (repo-wide)" },
                { "]Y", gh.last, mode = { "n", "x", "o" }, desc = "Last Hunk (repo-wide)" },
                { "[Y", gh.first, mode = { "n", "x", "o" }, desc = "First Hunk (repo-wide)" },
            }
        end,
    },
}
