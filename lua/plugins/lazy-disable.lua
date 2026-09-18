return {

    {
        "nvim-mini/mini.pairs",
        enabled = false,
    },
    {
        "folke/which-key.nvim",
        lazy = true,
        enabled = false,
        opts = {
            delay = 200,
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
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        enabled = false,
        -- lazy = true,
        dependencies = {
            {
                -- dep because my config uses repeatable-move
                "kiyoon/repeatable-move.nvim",
                dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
            },
        },
        opts = {
            focus = true,
            pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
            warn_no_results = true, -- show a warning when there are no results
            open_no_results = true, -- open the trouble window when there are no results

            position = "bottom",
            modes = {
                lsp = {
                    win = { position = "bottom" },
                },
                symbols = {
                    win = { type = "split", position = "bottom" },
                },
            },
        },
        keys = {
            { "<localleader>kq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
            { "<localleader>kw", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },

            { "<localleader>ky", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
            { "<localleader>kr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP references (Trouble)" },
            { "<localleader>kd", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "LSP definitions (Trouble)" },
            { "<localleader>kD", "<cmd>Trouble lsp_declarations toggle<cr>", desc = "LSP declarations (Trouble)" },
            { "<localleader>ky", "<cmd>Trouble lsp_type_definitions toggle<cr>", desc = "LSP type definitions (Trouble)" },
            { "<localleader>kI", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "LSP implementations (Trouble)" },
            { "<localleader>ks", "<cmd>Trouble symbols toggle focus=true<cr>", desc = "Symbols (Trouble)" },
            { "<localleader>kt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
            { "<localleader>kT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "TODO/FIX/FIXME Filtered (Trouble)" },

            { "<localleader>ka", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspae Diagnostics (Trouble)" },
            { "<localleader>kb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            -- bare triggers: loading runs config() which sets the real handlers, then the key is replayed
            -- { "[q", mode = { "n", "x", "o" }, desc = "Previous Trouble/Quickfix Item" },
            -- { "]q", mode = { "n", "x", "o" }, desc = "Next Trouble/Quickfix Item" },
        },
        config = function(_, opts)
            require("trouble").setup(opts)

            local function trouble_qf_next()
                if require("trouble").is_open() then
                    require("trouble").next({ skip_groups = true, jump = true })
                else
                    local ok = pcall(vim.cmd.cnext)
                    if not ok then
                        local ok2 = pcall(vim.cmd, "cc 1")
                        if not ok2 then
                            vim.notify("No quickfix list errors", vim.log.levels.ERROR)
                        end
                    end
                end
            end

            local function trouble_qf_prev()
                if require("trouble").is_open() then
                    require("trouble").prev({ skip_groups = true, jump = true })
                else
                    local ok = pcall(vim.cmd.cprev)
                    if not ok then
                        local ok2 = pcall(vim.cmd, "cc 1")
                        if not ok2 then
                            vim.notify("No quickfix list errors", vim.log.levels.ERROR)
                        end
                    end
                end
            end

            local repeatable_qf_next, repeatable_qf_prev = require("repeatable_move").make_repeatable_move_pair(trouble_qf_next, trouble_qf_prev)

            vim.keymap.set({ "n", "x", "o" }, "[q", repeatable_qf_prev, { desc = "Previous Trouble/Quickfix Item" })
            vim.keymap.set({ "n", "x", "o" }, "]q", repeatable_qf_next, { desc = "Next Trouble/Quickfix Item" })
        end,
    },
    {
        "folke/flash.nvim",
        enabled = false,
    },

    {
        "folke/noice.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            -- "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        opts = {
            -- cmdline = { enabled = true, view = "cmdline" },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = true,
                command_palette = false,
                long_message_to_split = true,
                lsp_doc_border = true,
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>sn", "", desc = "+noice"},
            { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
            { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
            { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
            { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
            { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
        },
        config = function(_, opts)
            -- HACK: noice shows messages from before it was enabled,
            -- but this is not ideal when Lazy is installing plugins,
            -- so clear the messages in this case.
            if vim.o.filetype == "lazy" then
                vim.cmd([[messages clear]])
            end
            require("noice").setup(opts)
        end,
    },
    { "akinsho/bufferline.nvim", enabled = false },
    {
        "nvim-lualine/lualine.nvim",
        enabled = false,
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
            vim.o.cmdheight = 0
        end,
        opts = function()
            -- PERF: we don't need this lualine require madness 🤷
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            local icons = LazyVim.config.icons

            vim.o.laststatus = vim.g.lualine_laststatus

            local opts = {
                options = {
                    theme = "auto",
                    globalstatus = vim.o.laststatus == 3,
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },

                    lualine_c = {
                        LazyVim.lualine.root_dir(),
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                        { LazyVim.lualine.pretty_path() },
                    },
                    lualine_x = {
                        Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed = gitsigns.removed,
                                    }
                                end
                            end,
                        },
                    },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%R")
                        end,
                    },
                },
                extensions = { "neo-tree", "lazy", "fzf" },
            }

            -- do not add trouble symbols if aerial is enabled
            -- And allow it to be overriden for some buffer types (see autocmds)
            if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
                local trouble = require("trouble")
                local symbols = trouble.statusline({
                    mode = "symbols",
                    groups = {},
                    title = false,
                    filter = { range = true },
                    format = "{kind_icon}{symbol.name:Normal}",
                    hl_group = "lualine_c_normal",
                })
                table.insert(opts.sections.lualine_c, {
                    symbols and symbols.get,
                    cond = function()
                        return vim.b.trouble_lualine ~= false and symbols.has()
                    end,
                })
            end

            return opts
        end,
    },
    {
        "folke/persistence.nvim",
        enabled = false,
        -- event = "BufReadPre",
        opts = {},
        keys = {
            {
                "<localleader>zq",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<localleader>ze",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<localleader>zr",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<localleader>zw",
                function()
                    require("persistence").save()
                end,
                desc = "Save Session",
            },
            {
                "<localleader>zp",
                function()
                    require("persistence").select()
                end,
                desc = "Select Session",
            },
            {
                "<localleader>zz",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<localleader>zd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },
}
