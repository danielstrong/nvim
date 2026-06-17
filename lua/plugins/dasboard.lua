return {
    {
        -- this shows just the lsp and is smaller and less annoying
        "j-hui/fidget.nvim",
        enabled = true,
        opts = {
            -- options
        },
    },
    {
        -- similair to fidget but little differnet also turns vim.notify into floating windows
        "nvim-mini/mini.notify",
        enabled = false,
        version = true,
        opts = { -- Content management
            content = {
                -- Function which formats the notification message
                -- By default prepends message with notification time
                format = nil,

                -- Function which orders notification array from most to least important
                -- By default orders first by level and then by update timestamp
                sort = nil,
            },

            -- Notifications about LSP progress
            lsp_progress = {
                -- Whether to enable showing
                enable = true,

                -- Notification level
                level = "INFO",

                -- Duration (in ms) of how long last message should be shown
                duration_last = 2000,
            },

            -- Window options
            window = {
                -- Floating window config
                config = {
                    anchor = "SE",
                    col = vim.o.columns,
                    row = vim.o.lines - vim.o.cmdheight - 1,
                },

                -- Maximum window width as share (between 0 and 1) of available columns
                max_width_share = 0.382,

                -- Value of 'winblend' option
                winblend = 25,
            },
        },
    },
    {
        "folke/snacks.nvim",
        -- enabled = false,
        -- @type snacks.Config
        opts = {
            zen = {
                enabled = true,
                toggles = {
                    dim = true,
                    git_signs = false,
                    mini_diff_signs = false,
                    -- diagnostics = false,
                    -- inlay_hints = false,
                },
                center = false,
                -- win = {
                -- style = "zen",
                -- backdrop = false,
                -- width = 0, -- full width
                -- },
                zoom = {
                    center = true,
                },
            },
            dashboard = { enabled = false },
            notifier = { enabled = false, top_down = false, style = "minimal", margin = { right = 0 } },
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
}
