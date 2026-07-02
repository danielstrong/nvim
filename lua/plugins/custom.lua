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
        event = "LazyFile",
        dev = true,
        config = function()
            local wm = require("window-move")

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { desc = desc, silent = true })
            end

            map({ "n", "x" }, "<localleader>wmk", function()
                wm.window_move("up")
            end, "Move Window Up")

            map({ "n", "x" }, "<localleader>wmj", function()
                wm.window_move("down")
            end, "Move Window Down")

            map({ "n", "x" }, "<localleader>wmh", function()
                wm.window_move("left")
            end, "Move Window Left")

            map({ "n", "x" }, "<localleader>wml", function()
                wm.window_move("right")
            end, "Move Window Right")
        end,
    },
    {
        "custom/project-check",
        event = "LazyFile",
        dev = true,
        config = function()
            local pc = require("project-check")

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { desc = desc, silent = true })
            end

            map("n", "<localleader>dw", function()
                pc.run_checks(true)
            end, "TSC + ESLint to Quickfix")

            map("n", "<localleader>dW", function()
                pc.run_checks(false)
            end, "TSC + ESLint to Quickfix (include warnings)")

            map("n", "<localleader>nl", pc.view_project_check_logs, "View Project Check logs")
        end,
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
