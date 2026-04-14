return {
    {
        "folke/snacks.nvim",
        -- enabled = false,
        -- @type snacks.Config
        opts = {
            dashboard = { enabled = false },
            notifier = { enabled = false },
            indent = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            picker = { enabled = false },
            -- statuscolumn = { enabled = false },
            ---@class snacks.terminal.Config
            terminal = { enabled = false },
            ---@class snacks.input.Config
            input = { enabled = false },
            ---@class snacks.explorer.Config
            explorer = { enabled = false },
            ---@class snacks.bigfile.Config
            bigfile = {
                enabled = true,
                notify = false,
                -- setup = function(ctx)
                --     -- Snacks.bigfile.setup(ctx)
                --     if vim.o.laststatus ~= 2 then
                --         vim.o.laststatus = 2
                --     end
                -- end,
            },
        },
    },
    {
        "folke/snacks.nvim",
        opts = function()
            -- Toggle the profiler
            Snacks.toggle.profiler():map("<leader>pp")
            -- Toggle the profiler highlights
            Snacks.toggle.profiler_highlights():map("<leader>ph")
        end,
        keys = {
            {
                "<leader>ps",
                function()
                    Snacks.profiler.scratch()
                end,
                desc = "Profiler Scratch Bufer",
            },
        },
    },
    {
        "folke/noice.nvim",
        enabled = false,
    },
}
