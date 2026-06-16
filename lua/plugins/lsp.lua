return {
    -- this fixes "vim" not being detected in lua config files
    -- { "folke/neodev.nvim", opts = {} },
    -- {
    -- "folke/lazydev.nvim",
    -- enabled = false,
    -- },
    {
        "neovim/nvim-lspconfig",
        opts = {

            -- options for vim.diagnostic.config()
            ---@type vim.diagnostic.Opts
            diagnostics = {
                underline = true,
                update_in_insert = false,
                float = {
                    border = "rounded",
                },
                -- virtual_text = {
                --     spacing = 4,
                --     source = "if_many",
                --     -- prefix = "●",
                --     -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                --     prefix = "icons",
                -- },
                -- virtual_text = false,
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
                        [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
                        [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
                        [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
                    },
                },
            },

            inlay_hints = {
                enabled = false, -- virtual text that shows up after parameters to tell you their data type
            },
            servers = {
                ["*"] = {
                    keys = {
                        {
                            "K",
                            function()
                                return vim.lsp.buf.hover({
                                    max_width = 120,
                                    max_height = 480,
                                    border = "rounded",
                                })
                            end,
                            desc = "Hover",
                            has = "hover",
                        },
                        { "<localleader>ah", vim.lsp.buf.document_highlight, desc = "Document Highlight" },
                        { "<localleader>aH", vim.lsp.buf.clear_references, desc = "Clear Document Highlight" },
                        { "<localleader>af", vim.lsp.buf.format, desc = "LSP Format" },
                        { "<localleader>ai", vim.lsp.buf.incoming_calls, desc = "LSP Incoming Calls" },
                        { "<localleader>aI", vim.lsp.buf.outgoing_calls, desc = "LSP Outoging Calls" },
                        {
                            "<localleader>at",
                            function()
                                vim.lsp.buf.typehierarchy("subtypes")
                            end,
                            desc = "LSP Type Hierarchy Subtypes",
                        },
                        {
                            "<localleader>aT",
                            function()
                                vim.lsp.buf.typehierarchy("supertypes")
                            end,
                            desc = "LSP Type Hierarchy Supertypes",
                        },
                        { "<localleader>aw", vim.lsp.buf.list_workspace_folders, desc = "LSP List Workspace Folders" },
                        { "<localleader>ao", vim.lsp.buf.workspace_symbol, desc = "LSP List Workspace Folders" },
                        { "cQ", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
                        -- { "cq", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
                        { "<localleader>ac", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
                        {
                            "<localleader>rf",
                            function()
                                Snacks.rename.rename_file({
                                    on_rename = function(_, _, ok)
                                        if ok then
                                            require("nvim-tree.api").tree.reload()
                                        end
                                    end,
                                })
                            end,
                            desc = "LSP Rename File",
                            mode = { "n" },
                            has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
                        },
                        { "<localleader>rc", vim.lsp.buf.rename, desc = "LSP Rename Reference", has = "rename" },
                    },
                },
                -- vtsls = {
                --     settings = {
                --         vtsls = {
                --             experimental = {
                --                 -- don't abbreviate long inlay-hint types with "..."
                --                 maxInlayHintLength = 100,
                --             },
                --         },
                --         typescript = {
                --             -- show full type signatures in hover instead of truncating
                --             tsserver = {
                --                 preferences = {
                --                     noErrorTruncation = true,
                --                 },
                --             },
                --         },
                --     },
                -- },
            },
        },
    },
    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            -- optional picker via telescope
            -- { "nvim-telescope/telescope.nvim" },
            -- optional picker via fzf-lua
            -- { "ibhagwan/fzf-lua" },
            -- .. or via snacks
            -- {
            --     "folke/snacks.nvim",
            --     opts = {
            --         terminal = {},
            --     },
            -- },
        },
        event = "LspAttach",
        opts = {
            -- picker = { "snacks" },
            -- picker = { "fzf-lua" },
            -- picker = { "select", opts = {} },

            backend = "vim",
            -- backend = "delta",
            picker = {
                "buffer",
                opts = {
                    hotkeys = true, -- Enable hotkeys for quick selection of actions
                    hotkeys_mode = "text_based", -- Modes for generating hotkeys
                    -- hotkeys_mode = "text_diff_based", -- Modes for generating hotkeys
                    auto_preview = true, -- Enable or disable automatic preview
                    auto_accept = true, -- Automatically accept the selected action (with hotkeys)
                    position = "cursor", -- Position of the picker window
                    -- position = "center", -- Position of the picker window
                    -- winborder = "single", -- Border style for picker and preview windows
                    winborder = "rounded", -- Border style for picker and preview windows
                    keymaps = {
                        preview = "K", -- Key to show preview
                        close = { "q", "<Esc>" }, -- Keys to close the window (can be string or table)
                        select = "<CR>", -- Keys to select action (can be string or table)
                        preview_close = { "q", "<Esc>" }, -- Keys to return from preview to main window (can be string or table)
                    },
                    custom_keys = {
                        { key = "m", pattern = "Fill match arms" },
                        { key = "m", pattern = "Consider making this binding mutable: mut" },
                        { key = "r", pattern = "Rename.*" }, -- Lua pattern matching
                        { key = "e", pattern = "Extract Method" },
                    },
                    group_icon = " └",
                },
            },

            -- Sort import-related actions to the top (within their category group)
            sort = function(a, b)
                local function is_import(item)
                    local action = item.action or {}
                    local title = (action.title or ""):lower()
                    local kind = (action.kind or ""):lower()
                    return title:find("import", 1, true) ~= nil or kind:find("import", 1, true) ~= nil
                end

                local a_import = is_import(a)
                local b_import = is_import(b)
                if a_import ~= b_import then
                    return a_import
                end

                -- preserve the isPreferred-first ordering applied before this comparator
                local a_pref = a.action and a.action.isPreferred == true
                local b_pref = b.action and b.action.isPreferred == true
                if a_pref ~= b_pref then
                    return a_pref
                end

                return false
            end,

            -- resolve_timeout = 100, -- Timeout in milliseconds to resolve code actions

            -- Notification settings
            notify = {
                enabled = true, -- Enable/disable all notifications
                on_empty = true, -- Show notification when no code actions are found
            },

            -- Customize how action titles are displayed in the picker
            -- Function receives (action, client) and returns a formatted string
            -- Default: action.title
            -- format_title = nil,

            -- The icons to use for the code actions
            -- You can add your own icons, you just need to set the exact action's kind of the code action
            -- You can set the highlight like so: { link = "DiagnosticError" } or  like nvim_set_hl ({ fg ..., bg..., bold..., ...})
            signs = {
                quickfix = { "", { link = "DiagnosticWarning" } },
                others = { "", { link = "DiagnosticWarning" } },
                refactor = { "", { link = "DiagnosticInfo" } },
                ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
                ["refactor.extract"] = { "", { link = "DiagnosticError" } },
                ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
                ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
                ["source"] = { "", { link = "DiagnosticError" } },
                ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
                ["codeAction"] = { "", { link = "DiagnosticWarning" } },
            },
        },
        config = function(_, opts)
            require("tiny-code-action").setup(opts)

            vim.keymap.set({ "n", "x" }, "cq", function()
                require("tiny-code-action").code_action({
                    -- sort = function(a, b)
                    --     local function get_priority(kind)
                    --         if string.match(kind or "", "^quickfix") then
                    --             return 1
                    --         end
                    --         if string.match(kind or "", "^refactor") then
                    --             return 2
                    --         end
                    --         return 3
                    --     end
                    --
                    --     local a_priority = get_priority(a.action.kind)
                    --     local b_priority = get_priority(b.action.kind)
                    --
                    --     return a_priority < b_priority
                    -- end,
                })
            end, { noremap = true, silent = true, desc = "Code" })
        end,
    },
    {
        "nemanjamalesija/ts-expand-hover.nvim",
        ft = { "typescript", "typescriptreact" },
        opts = {
            keymaps = {
                hover = "<localleader>UK",
                expand = "o",
                collapse = "i",
            },
            float = {
                border = "rounded",
                max_width = 120,
                max_height = 40,
                -- max_width = 80,
                -- max_height = 30,
            },
        },
    },
}
