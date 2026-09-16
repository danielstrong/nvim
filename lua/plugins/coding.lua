return {
    {
        "nvim-mini/mini.surround",
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local opts = LazyVim.opts("mini.surround")
            local mappings = {
                { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "x" } },
                { opts.mappings.delete, desc = "Delete Surrounding" },
                { opts.mappings.find, desc = "Find Right Surrounding" },
                { opts.mappings.find_left, desc = "Find Left Surrounding" },
                { opts.mappings.highlight, desc = "Highlight Surrounding" },
                { opts.mappings.replace, desc = "Replace Surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                replace = "gsr", -- Replace surrounding
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                update_n_lines = "gsn", -- Update `n_lines`
            },
        },
    },
    {
        "nvim-mini/mini.operators",
        event = "VeryLazy",
        opts = {
            replace = {
                prefix = "s",
            },
            exchange = { prefix = "gmx" }, -- Exchange with register
            multiply = { prefix = "gmm" },
            sort = { prefix = "gms" },
        },
    },
    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
        keys = {
            {
                "gmk",
                function()
                    require("treesj").split()
                end,
                mode = { "n", "x" },
                desc = "Split Line",
            },
            {
                "gmK",
                function()
                    require("treesj").split({ split = { recursive = true } })
                end,
                mode = { "n", "x" },
                desc = "Split Line (recursive)",
            },
            {
                "gmj",
                function()
                    require("treesj").join()
                end,
                mode = { "n", "x" },
                desc = "Join Line",
            },
            {
                "gmJ",
                function()
                    require("treesj").join({ split = { recursive = true } })
                end,
                mode = { "n", "x" },
                desc = "Join Line (recursive)",
            },
        },
        opts = {
            use_default_keymaps = false,
            max_join_length = 15000,
            dot_repeat = false,
        },
    },
}
