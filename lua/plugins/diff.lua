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
            -- Toggle diffview open/close (file panel visibility is remembered
            -- across toggles via the `oe` mapping below; closed by default)
            { "<localleader>oo", "<cmd>DiffviewToggle<cr>", mode = "n", desc = "Toggle Diffview" },
            { "<localleader>oO", "<cmd>DiffviewOpen<cr><cmd>DiffviewToggleFiles<cr>", desc = "Diffview open" },
            {
                "<localleader>oe",
                function()
                    vim.cmd("DiffviewToggleFiles")
                    local view = require("diffview.lib").get_current_view()
                    if view and view.panel then
                        require("diffview.config").get_config().file_panel.show = view.panel:is_open()
                    end
                end,
                mode = "n",
                desc = "Toggle files",
            },
            { "<localleader>ox", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },

            -- Toggle diff for the current file only (Diffview alternative to <localleader>gd)
            {
                "<localleader>od",
                function()
                    if require("diffview.lib").get_current_view() then
                        vim.cmd("DiffviewClose")
                    else
                        vim.cmd("DiffviewOpen -- " .. vim.fn.fnameescape(vim.fn.expand("%:p")))
                    end
                end,
                mode = "n",
                desc = "Toggle file diff (Diffview)",
            },

            -- Toggle diff for the current file against the last commit (Diffview alternative to <localleader>gD)
            {
                "<localleader>oD",
                function()
                    if require("diffview.lib").get_current_view() then
                        vim.cmd("DiffviewClose")
                    else
                        vim.cmd("DiffviewOpen HEAD~1 -- " .. vim.fn.fnameescape(vim.fn.expand("%:p")))
                    end
                end,
                mode = "n",
                desc = "Toggle file diff against last commit (Diffview)",
            },

            -- File history
            { "<localleader>oh", "<cmd>DiffviewFileHistory %<cr>", mode = "n", desc = "File history (current file)" },
            { "<localleader>oH", "<cmd>DiffviewFileHistory<cr>", mode = "n", desc = "File history (repo)" },

            -- Visual mode: history for selection
            {
                "<localleader>oh",
                "<Esc><cmd>'<,'>DiffviewFileHistory --follow<CR>",
                mode = "x",
                desc = "Range history",
            },

            -- Single line history
            { "<localleader>ol", "<cmd>.DiffviewFileHistory --follow<CR>", mode = "n", desc = "Line history" },

            -- Diff against main/master branch (useful before merging)
            {
                "<localleader>om",
                function()
                    -- Try main first, fall back to master
                    local result = vim.fn.systemlist({ "git", "rev-parse", "--verify", "main" })
                    local ok = vim.v.shell_error == 0 and result[1] ~= nil and result[1] ~= ""
                    local branch = ok and "main" or "master"
                    vim.cmd("DiffviewOpen " .. branch)
                end,
                mode = "n",
                desc = "Diff against main/master",
            },
        },
        opts = {
            enhanced_diff_hl = true,
            use_icons = true,
            view = {
                default = { layout = "diff2_horizontal" },
                merge_tool = { layout = "diff3_horizontal" },
                cycle_layouts = {
                    default = { "diff2_horizontal", "diff1_inline" },
                },
            },
            file_panel = {
                listing_style = "tree",
                win_config = { position = "left", width = 35 }, -- Use "auto" to fit content
                show = false, -- Closed by default; `oe` toggle remembers state across `oo`
            },
            hooks = {}, -- See :h diffview-config-hooks
            keymaps = {}, -- See :h diffview-config-keymaps
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
}
