return {
    {
        "folke/which-key.nvim",
        lazy = true,
        enabled = false,
        opts = {
            delay = function(ctx)
                -- vim.notify(vim.inspect(ctx))
                if ctx.mode == "o" then
                    return 1000
                elseif ctx.keys == "z" or ctx.keys == "g" then
                    return 800
                elseif ctx.keys == (vim.g.maplocalleader or "\\") then
                    return 500
                end
                return 500
            end,
            -- preset = "classic",
            -- preset = "modern",
            preset = "helix",
            plugins = {
                marks = true, -- shows a list of your marks on ' and `
                registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                -- No actual key bindings are created
                spelling = {
                    enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                    suggestions = 20, -- how many suggestions should be shown in the list?
                },
                presets = {
                    operators = true, -- adds help for operators like d, y, ...
                    motions = false, -- adds help for motions
                    text_objects = true, -- help for text objects triggered after entering an operator
                    windows = true, -- default bindings on <c-w>
                    nav = true, -- misc bindings to work with windows
                    z = true, -- bindings for folds, spelling and others prefixed with z
                    g = true, -- bindings for prefixed with g
                },
            },
            -- triggers = {
            --     { "<auto>", mode = "nxso" },
            --     { "<leader>", mode = { "n", "v" } },
            --     { "<localleader>", mode = { "n", "v" } },
            --     { "c", mode = { "n", "v" } },
            -- },
            -- sort = { "local", "order", "group", "alphanum", "mod" },
            -- sort = { "alphanum", "order", "group", "mod", "local" },
            sort = { "alphanum", "order", "mod" },
            spec = {
                { "<localleader>a", group = "Actions", mode = { "n", "x" } },
                { "<localleader>o", group = "Diffview", mode = { "n", "x" } },
                { "<localleader>K", group = "LSP Buffer", mode = { "n", "x" } },
                { "<localleader>N", group = "Nvim Raw", mode = { "n", "x" } },
                { "<localleader>Q", group = "Quick", mode = { "n", "x" } },
                { "<localleader>W", group = "Save", mode = { "n", "x" } },
                { "<localleader>d", group = "Diff Tools", mode = { "n", "x" } },
                { "<localleader>f", group = "Fuzzy", mode = { "n", "x" } },
                { "<localleader>g", group = "Git", mode = { "n", "x" } },
                { "<localleader>h", group = "Hunk", mode = { "n", "x" } },
                { "<localleader>j", group = "Copy Store", mode = { "n", "x" } },
                { "<localleader>k", group = "Language Tools", mode = { "n", "x" } },
                { "<localleader>n", group = "Nvim", mode = { "n", "x" } },
                { "<localleader><localleader>", group = "Ctrl", mode = { "n", "x" } },
                { "<C-q>", group = "Tabs", mode = { "n", "x" } },
                { "<C-q>m", group = "Move Tab", mode = { "n", "x" } },
                { "<localleader>t", group = "Tabs", mode = { "n", "x" } },
                { "<localleader>tm", group = "Move Tab", mode = { "n", "x" } },
                { "<localleader>r", group = "Replace", mode = { "n", "x" } },
                { "<localleader>u", group = "UI", mode = { "n", "x" } },
                { "<localleader>z", group = "Session", mode = { "n", "x" } },
                { "Z", group = "File", mode = { "n", "x" } },
                { "gm", group = "Modify Code", mode = { "n", "x" } },
                { "<localleader>=", group = "Fix Indention", mode = { "n", "x" } },
                { "<localleader>=z", group = "Formatters", mode = { "n", "x" } },
                {
                    "<localleader>b",
                    group = "Buffers",
                    expand = function()
                        return require("which-key.extras").expand.buf()
                    end,
                    mode = { "n", "x" },
                },
                {
                    "<localleader>w",
                    group = "Windows",
                    proxy = "<c-w>",
                    expand = function()
                        return require("custom-utils.tabs_windows_buffers").wk_window_jump_expand()
                    end,
                    mode = { "n", "x" },
                },
                {
                    "<localleader>wm",
                    group = "Move Window",
                    expand = function()
                        return require("custom-utils.tabs_windows_buffers").wk_window_move_expand()
                    end,
                    mode = { "n", "x" },
                },
                {
                    "<C-w>",
                    group = "Windows",
                    expand = function()
                        return require("custom-utils.tabs_windows_buffers").wk_window_jump_expand()
                    end,
                    mode = { "n", "x" },
                },
                {
                    "<C-w>m",
                    group = "Move Window",
                    expand = function()
                        return require("custom-utils.tabs_windows_buffers").wk_window_move_expand()
                    end,
                    mode = { "n", "x" },
                },
                unpack(require("custom-utils.tabs_windows_buffers").wk_tab_specs()),
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = true })
                end,
                desc = "Global Keymaps ",
            },
            {
                "<localleader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Local Keymaps",
            },
        },
    },
}
