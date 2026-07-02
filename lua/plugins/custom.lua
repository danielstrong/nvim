return {
    {
        "custom/copy-store",
        event = "LazyFile",
        dev = true,
        dependencies = { "ibhagwan/fzf-lua" },
        config = function()
            local cs = require("copy-store")

            cs.setup({
                -- Extra absolute dirs (~ allowed) that act as full copy stores:
                -- they're listed for paste/edit and offered as save targets, so
                -- copies can be created and renamed in them just like the nvim
                -- copies/ dir. Example: extra_dirs = { "~/my-prompts" }
                extra_dirs = vim.g.is_mac and {
                    "~/.claude/custom-system-prompts",
                    "~/.config/clp/context",
                } or nil,
            })

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { desc = desc, silent = true })
            end

            map({ "n", "x" }, "<localleader>jn", cs.create_copy_store_entry, "Create New Copy for Copy Store")

            map({ "n", "x" }, "<localleader>jo", cs.edit_copy_store_entry, "Modify Copy from Copy Store")

            map({ "n", "x" }, "<localleader>jp", cs.paste_copy_store_entry, "Paste Copy from Copy Store")

            map({ "n", "x" }, "<localleader>jP", cs.paste_cwd_entry, "Paste Copy from CWD")

            map({ "n", "x" }, "<localleader>jO", cs.edit_cwd_entry, "Modify Copy from CWD")
        end,
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
        config = function()
            local gh = require("githunks")

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { desc = desc, silent = true })
            end
            local repeat_move = require("repeatable_move")
            local repeatable_next_yhunk, repeatable_prev_yhunk = repeat_move.make_repeatable_move_pair(gh.next_unstaged, gh.prev_unstaged)
            map({ "n", "x", "o" }, "]g", repeatable_next_yhunk, "Next Unstaged Hunk (repo-wide)")
            map({ "n", "x", "o" }, "[g", repeatable_prev_yhunk, "Prev Unstaged Hunk (repo-wide)")
            map({ "n", "x", "o" }, "]G", gh.last_unstaged, "Last Unstaged Hunk (repo-wide)")
            map({ "n", "x", "o" }, "[G", gh.first_unstaged, "First Unstaged Hunk (repo-wide)")

            local repeatable_next_ghunk, repeatable_prev_ghunk = repeat_move.make_repeatable_move_pair(gh.next, gh.prev)
            map({ "n", "x", "o" }, "]y", repeatable_next_ghunk, "Next Hunk (repo-wide)")
            map({ "n", "x", "o" }, "[y", repeatable_prev_ghunk, "Prev Hunk (repo-wide)")
            map({ "n", "x", "o" }, "]Y", gh.last, "Last Hunk (repo-wide)")
            map({ "n", "x", "o" }, "[Y", gh.first, "First Hunk (repo-wide)")
        end,
    },
}
