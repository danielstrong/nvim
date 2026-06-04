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
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>ps",
                function()
                    Snacks.profiler.scratch()
                end,
                desc = "Profiler Scratch Bufer",
            },
        },
        opts = function()
            -- Toggle the profiler
            Snacks.toggle.profiler():map("<leader>pp")
            -- Toggle the profiler highlights
            Snacks.toggle.profiler_highlights():map("<leader>ph")

            -- -- Lsp progreess notification
            -- ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
            -- local progress = vim.defaulttable()
            -- vim.api.nvim_create_autocmd("LspProgress", {
            --     ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
            --     callback = function(ev)
            --         local client = vim.lsp.get_client_by_id(ev.data.client_id)
            --         local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
            --         if not client or type(value) ~= "table" then
            --             return
            --         end
            --         local p = progress[client.id]
            --
            --         for i = 1, #p + 1 do
            --             if i == #p + 1 or p[i].token == ev.data.params.token then
            --                 p[i] = {
            --                     token = ev.data.params.token,
            --                     msg = ("[%3d%%] %s%s"):format(value.kind == "end" and 100 or value.percentage or 100, value.title or "", value.message and (" **%s**"):format(value.message) or ""),
            --                     done = value.kind == "end",
            --                 }
            --                 break
            --             end
            --         end
            --
            --         local msg = {} ---@type string[]
            --         progress[client.id] = vim.tbl_filter(function(v)
            --             return table.insert(msg, v.msg) or not v.done
            --         end, p)
            --
            --         local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            --         vim.notify(("[%s] %s"):format(client.name, table.concat(msg, "\n")), "info", {
            --             id = "lsp_progress",
            --             title = client.name,
            --             opts = function(notif)
            --                 notif.icon = #progress[client.id] == 0 and " " or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            --             end,
            --         })
            --     end,
            -- })

            -- Reposition notifier windows to the left
            -- vim.api.nvim_create_autocmd("FileType", {
            --     pattern = "snacks_notif",
            --     callback = function(ev)
            --         vim.schedule(function()
            --             local win = vim.fn.bufwinid(ev.buf)
            --             if win == -1 then return end
            --             local ok, config = pcall(vim.api.nvim_win_get_config, win)
            --             if ok and config.relative == "editor" then
            --                 config.col = 1
            --                 pcall(vim.api.nvim_win_set_config, win, config)
            --             end
            --         end)
            --     end,
            -- })
        end,
    },
}
