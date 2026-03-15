return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                apexcode = { "prettier" },
            },
            formatters = {
                prettier = {
                    condition = function(self, ctx)
                        local ft = vim.bo[ctx.buf].filetype
                        if ft == "apexcode" then
                            return true
                        end
                        -- fall back to LazyVim's default condition
                        local prettier_extra = require("lazyvim.plugins.extras.formatting.prettier")
                        return prettier_extra.has_parser(ctx)
                    end,
                },
            },
        },
    },
    {
        "nvim-mini/mini.pairs",
        enabled = false,
    },
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
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
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
            exchange = { prefix = "gx" }, -- Exchange with register
            multiply = { prefix = "gm" },
            sort = { prefix = "gS" },
        },
    },
}
