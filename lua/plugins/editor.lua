return {
    {
        enabled = false,
        "esmuellert/codediff.nvim",
        cmd = "CodeDiff",
        opts = {
            --   highlights = {
            --   -- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
            --   line_insert = "DiffAdd",      -- Line-level insertions
            --   line_delete = "DiffDelete",   -- Line-level deletions
            --
            --   -- Character-level: accepts highlight group names or hex colors
            --   -- If specified, these override char_brightness calculation
            --   char_insert = nil,            -- Character-level insertions (nil = auto-derive)
            --   char_delete = nil,            -- Character-level deletions (nil = auto-derive)
            --
            --   -- Brightness multiplier (only used when char_insert/char_delete are nil)
            --   -- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
            --   char_brightness = nil,        -- Auto-adjust based on your colorscheme
            --
            --   -- Conflict sign highlights (for merge conflict views)
            --   -- Accepts highlight group names or hex colors (e.g., "#f0883e")
            --   -- nil = use default fallback chain
            --   conflict_sign = nil,          -- Unresolved: DiagnosticSignWarn -> #f0883e
            --   conflict_sign_resolved = nil, -- Resolved: Comment -> #6e7681
            --   conflict_sign_accepted = nil, -- Accepted: GitSignsAdd -> DiagnosticSignOk -> #3fb950
            --   conflict_sign_rejected = nil, -- Rejected: GitSignsDelete -> DiagnosticSignError -> #f85149
            -- },
            diff = {
                -- layout = "side-by-side",             -- Diff layout: "side-by-side" (two panes) or "inline" (single pane with virtual lines)
                layout = "inline",
                -- disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
                -- max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
                -- ignore_trim_whitespace = false, -- Ignore leading/trailing whitespace changes (like diffopt+=iwhite)
                -- hide_merge_artifacts = false, -- Hide merge tool temp files (*.orig, *.BACKUP.*, *.BASE.*, *.LOCAL.*, *.REMOTE.*)
                -- original_position = "left", -- Position of original (old) content: "left" or "right"
                -- conflict_ours_position = "right", -- Position of ours (:2) in conflict view: "left" or "right"
                -- conflict_result_position = "bottom", -- "bottom" (default): result below diff panes or "center": result between diff panes (three columns)
                -- conflict_result_height = 30, -- Height of result pane in bottom layout (% of total height)
                -- conflict_result_width_ratio = { 1, 1, 1 }, -- Width ratio for center layout panes {left, center, right} (e.g., {1, 2, 1} for wider result)
                -- cycle_next_hunk = true, -- Wrap around when navigating hunks (]c/[c): false to stop at first/last
                -- cycle_next_file = true, -- Wrap around when navigating files (]f/[f): false to stop at first/last
                -- cycle_hunks_across_files = false, -- ]c/[c at file boundary hops to first/last hunk of next/prev file (explorer/history)
                -- jump_to_first_change = true, -- Auto-scroll to first change when opening a diff: false to stay at same line
                -- highlight_priority = 100, -- Priority for line-level diff highlights (increase to override LSP highlights)
                -- compute_moves = false, -- Detect moved code blocks (opt-in, matches VSCode experimental.showMoves)
                -- compact_context_lines = 3, -- Number of context lines around hunks in compact mode
                -- compact_sync_folds = true, -- Sync fold open/close across panes (mirrors Vim diff mode behavior)
            },
            -- Explorer panel configuration
            explorer = {
                --       position = "left",  -- "left" or "bottom"
                --       hidden = false,  -- Initial visibility state
                --       width = 40,         -- Width when position is "left" (columns)
                --       height = 15,        -- Height when position is "bottom" (lines)
                --       auto_refresh = true,  -- Auto-refresh file list on focus / git index changes (set false to avoid lag in huge repos; R still refreshes manually)
                --       indent_markers = true,  -- Show indent markers in tree view (│, ├, └)
                -- initial_focus = "explorer",  -- Initial focus: "explorer", "original", or "modified"
                initial_focus = "modified", -- Initial focus: "explorer", "original", or "modified"
                --       icons = {
                --         folder_closed = "",  -- Nerd Font folder icon (customize as needed)
                --         folder_open = "",    -- Nerd Font folder-open icon
                --       },
                --       view_mode = "list",    -- "list" or "tree"
                --       flatten_dirs = true,   -- Flatten single-child directory chains in tree view
                --       file_filter = {
                --         ignore = { ".git/**", ".jj/**" },  -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
                --       },
                --       focus_on_select = false,  -- Jump to modified pane after selecting a file (default: stay in explorer)
                --       auto_open_on_cursor = false, -- Rebind j/k/Down/Up in the explorer to also open the file under the cursor
                --       status_right_margin = 1,  -- Trailing cells between status symbol (M/A/D) and right edge; increase if Nerd Font icons clip it
                --       visible_groups = {       -- Which groups to show (can be toggled at runtime)
                --         staged = true,
                --         unstaged = true,
                --         conflicts = true,
                --       },
            },

            -- History panel configuration (for :CodeDiff history)
            -- history = {
            --   position = "bottom",  -- "left" or "bottom" (default: bottom)
            --   width = 40,           -- Width when position is "left" (columns)
            --   height = 15,          -- Height when position is "bottom" (lines)
            --   initial_focus = "history",  -- Initial focus: "history", "original", or "modified"
            --   view_mode = "list",   -- "list" or "tree" for files under commits
            -- },

            -- Keymaps in diff view
            keymaps = {
                view = {
                    quit = "q", -- Close diff tab
                    toggle_explorer = "<leader>b", -- Toggle explorer visibility (explorer mode only)
                    focus_explorer = "<leader>e", -- Focus explorer panel (explorer mode only)
                    next_hunk = "]c", -- Jump to next change
                    prev_hunk = "[c", -- Jump to previous change
                    next_file = "]f", -- Next file in explorer/history mode
                    prev_file = "[f", -- Previous file in explorer/history mode
                    diff_get = "do", -- Get change from other buffer (like vimdiff)
                    diff_put = "dp", -- Put change to other buffer (like vimdiff)
                    open_in_prev_tab = "gf", -- Open current buffer in previous tab (or create one before)
                    close_on_open_in_prev_tab = false, -- Close codediff tab after gf opens file in previous tab
                    toggle_stage = "-", -- Stage/unstage current file (works in explorer and diff buffers)
                    stage_hunk = "<leader>hs", -- Stage hunk under cursor to git index
                    unstage_hunk = "<leader>hu", -- Unstage hunk under cursor from git index
                    discard_hunk = "<leader>hr", -- Discard hunk under cursor (working tree only)
                    hunk_textobject = "ih", -- Textobject for hunk (vih to select, yih to yank, etc.)
                    show_help = "g?", -- Show floating window with available keymaps
                    align_move = "gm", -- Temporarily align moved code blocks across panes
                    toggle_layout = "t", -- Toggle between side-by-side and inline layout
                    toggle_compact = "gc", -- Toggle compact mode (fold unchanged regions)
                },
                explorer = {
                    select = "<CR>", -- Open diff for selected file
                    hover = "K", -- Show file diff preview
                    refresh = "R", -- Refresh git status
                    toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
                    stage_all = "S", -- Stage all files
                    unstage_all = "U", -- Unstage all files
                    restore = "X", -- Discard changes (restore file)
                    toggle_changes = "gu", -- Toggle Changes (unstaged) group visibility
                    toggle_staged = "gs", -- Toggle Staged Changes group visibility
                    -- Fold keymaps (Vim-style)
                    fold_open = "zo", -- Open fold (expand current node)
                    fold_open_recursive = "zO", -- Open fold recursively (expand all descendants)
                    fold_close = "zc", -- Close fold (collapse current node)
                    fold_close_recursive = "zC", -- Close fold recursively (collapse all descendants)
                    fold_toggle = "za", -- Toggle fold (expand/collapse current node)
                    fold_toggle_recursive = "zA", -- Toggle fold recursively
                    fold_open_all = "zR", -- Open all folds in tree
                    fold_close_all = "zM", -- Close all folds in tree
                },
                history = {
                    select = "<CR>", -- Select commit/file or toggle expand
                    toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
                    refresh = "R", -- Refresh history (re-fetch commits)
                    -- Fold keymaps (Vim-style, apply to directory nodes only)
                    fold_open = "zo", -- Open fold (expand current node)
                    fold_open_recursive = "zO", -- Open fold recursively (expand all descendants)
                    fold_close = "zc", -- Close fold (collapse current node)
                    fold_close_recursive = "zC", -- Close fold recursively (collapse all descendants)
                    fold_toggle = "za", -- Toggle fold (expand/collapse current node)
                    fold_toggle_recursive = "zA", -- Toggle fold recursively
                    fold_open_all = "zR", -- Open all folds in tree
                    fold_close_all = "zM", -- Close all folds in tree
                },
                conflict = {
                    accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
                    accept_current = "<leader>co", -- Accept current (ours/right) change
                    accept_both = "<leader>cb", -- Accept both changes (incoming first)
                    discard = "<leader>cx", -- Discard both, keep base
                    -- Accept all (whole file) - uppercase versions
                    accept_all_incoming = "<leader>cT", -- Accept ALL incoming changes
                    accept_all_current = "<leader>cO", -- Accept ALL current changes
                    accept_all_both = "<leader>cB", -- Accept ALL both changes
                    discard_all = "<leader>cX", -- Discard ALL, reset to base
                    next_conflict = "]x", -- Jump to next conflict
                    prev_conflict = "[x", -- Jump to previous conflict
                    diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
                    diffget_current = "3do", -- Get hunk from current (right/ours) buffer
                },
            },
        },

        keys = {
            { "<localleader>ge", "<cmd>CodeDiff<cr>", desc = "Show Codediff" },
            { "<localleader>gE", "<cmd>CodDdiff --side-by-side<cr>", desc = "Show Codediff side-by-side" },
        },
    },
    {
        enabled = false,
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            -- Only one of these is needed.
            -- "sindrets/diffview.nvim", -- optional
            "esmuellert/codediff.nvim", -- optional

            -- For a custom log pager
            -- "m00qek/baleia.nvim", -- optional

            -- Only one of these is needed.
            -- "nvim-telescope/telescope.nvim", -- optional
            -- "ibhagwan/fzf-lua", -- optional
            -- "nvim-mini/mini.pick", -- optional
            -- "folke/snacks.nvim", -- optional
        },
        cmd = "Neogit",
        keys = {
            { "<localleader>gu", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
        },
    },
    {
        -- this shows just the lsp loading notification and is smaller and less annoying
        "j-hui/fidget.nvim",
        enabled = false,
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
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
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

            { "<localleader>da", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspae Diagnostics (Trouble)" },
            { "<localleader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
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
        "folke/which-key.nvim",
        lazy = true,
        -- enabled = false,
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
                -- { "c", group = "Replace Text", mode = { "n", "x" } },
                -- { "cr", mode = { "n" } },
                { "Z", group = "File", mode = { "n", "x" } },
                { "<localleader>a", group = "Actions", mode = { "n", "x" } },
                {
                    "<localleader>b",
                    group = "Buffers",
                    expand = function()
                        return require("which-key.extras").expand.buf()
                    end,
                    mode = { "n", "x" },
                },
                { "<localleader>d", group = "Diagnostics", mode = { "n", "x" } },
                { "<localleader>f", group = "Fuzzy", mode = { "n", "x" } },
                { "<localleader>g", group = "Git", mode = { "n", "x" } },
                { "<localleader>h", group = "Hunk", mode = { "n", "x" } },
                { "<localleader>k", group = "LSP", mode = { "n", "x" } },
                { "<localleader>K", group = "LSP Buffer", mode = { "n", "x" } },
                { "<localleader>n", group = "Nvim", mode = { "n", "x" } },
                { "<localleader>N", group = "Nvim Raw", mode = { "n", "x" } },
                { "<localleader>j", group = "Copy Store", mode = { "n", "x" } },
                { "<localleader>Q", group = "Quick", mode = { "n", "x" } },
                { "<localleader>r", group = "Replace", mode = { "n", "x" } },
                { "<localleader>z", group = "Session", mode = { "n", "x" } },
                { "<localleader>W", group = "Save", mode = { "n", "x" } },
                { "<localleader>t", group = "Tabs", mode = { "n", "x" } },
                { "<localleader>tm", group = "Move Tab", mode = { "n", "x" } },
                { "<localleader>u", group = "UI", mode = { "n", "x" } },
                {
                    "<localleader>w",
                    group = "Windows",
                    proxy = "<c-w>",
                    expand = function()
                        local extras = require("which-key.extras")
                        local ret = {}
                        for i = 1, vim.fn.winnr("$") do
                            local win = vim.fn.win_getid(i)
                            if vim.api.nvim_win_get_config(win).relative == "" then
                                local buf = vim.api.nvim_win_get_buf(win)
                                local name = extras.bufname(buf)
                                ret[#ret + 1] = {
                                    tostring(i),
                                    function()
                                        vim.cmd(i .. "wincmd w")
                                    end,
                                    desc = name,
                                    icon = { cat = "file", name = name },
                                }
                            end
                        end
                        return ret
                    end,
                    mode = { "n", "x" },
                },
                {
                    "<localleader>wm",
                    group = "Move Window",
                    expand = function()
                        local extras = require("which-key.extras")
                        local wm = require("window-move")
                        local ret = {}
                        for i = 1, vim.fn.winnr("$") do
                            local win = vim.fn.win_getid(i)
                            if vim.api.nvim_win_get_config(win).relative == "" then
                                local buf = vim.api.nvim_win_get_buf(win)
                                local name = extras.bufname(buf)
                                ret[#ret + 1] = {
                                    tostring(i),
                                    function()
                                        wm.window_swap_to(i)
                                    end,
                                    desc = "Move to " .. name,
                                    icon = { cat = "file", name = name },
                                    mode = { "n", "x" },
                                }
                            end
                        end
                        return ret
                    end,
                    mode = { "n", "x" },
                },
                { "<localleader>=", group = "Fix Indention", mode = { "n", "x" } },
                { "<localleader>=z", group = "Formatters", mode = { "n", "x" } },
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
        "rcarriga/nvim-notify",
        enabled = false,
        event = "VeryLazy",
        keys = {
            {
                "<localleader>nd",
                function()
                    require("notify").dismiss({ silent = false, pending = true })
                end,
                desc = "Dismiss notifications",
            },
            { "<localleader>nh", "<cmd>Notifications<CR>", desc = "Notification History" },
        },
        opts = {
            timeout = 3000,
            stages = "static",
            render = "wrapped-compact",
            merge_duplicates = 2,
            top_down = true,
            -- max_height = function()
            --     return math.floor(vim.o.lines * 0.75)
            -- end,
            -- max_width = function()
            --     return math.floor(vim.o.columns * 0.75)
            -- end,
        },
        config = function(_, opts)
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
        end,
    },
    {
        "christoomey/vim-tmux-navigator",
        event = "VimEnter",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    -- minimilistic minimap
    {
        "dstein64/nvim-scrollview",
        enabled = true,
        config = function()
            require("scrollview").setup({
                on_startup = false,
                excluded_filetypes = { "nerdtree" },
                hide_on_text_intersect = true,
                -- signs_scrollbar_overlap = "under",
                -- current_only = true,
                -- base = "buffer",
                -- column = 80,
                -- signs_on_startup = { "all" },
                signs_on_startup = { "latestchange", "conflicts", "diagnostics", "cursor", "folds", "keywords", "search", "spell" },
                -- signs_on_startup = { "diagnostics", "folds", "keywords", "search", "spell" },
                -- diagnostics_severities = { vim.diagnostic.severity.ERROR },
            })
            -- Uncoment below to show gitsigns in the minimap
            -- require("scrollview.contrib.gitsigns").setup({ enabled = true, only_first_line = true })
            Snacks.toggle
                .new({
                    name = "Scrollview",
                    get = function()
                        return vim.g.scrollview_enabled
                    end,
                    set = function(state)
                        if state then
                            vim.cmd("ScrollViewEnable")
                        else
                            vim.cmd("ScrollViewDisable")
                        end
                    end,
                })
                :map("<localleader>um")
        end,
    },
    {
        "nvim-mini/mini.nvim",
        event = "VeryLazy",
        version = false,
        enabled = true,
        config = function(_, opts)
            local mini_map = require("mini.map")
            mini_map.setup({
                -- Highlight integrations (none by default)
                integrations = {
                    mini_map.gen_integration.builtin_search(),
                    mini_map.gen_integration.diff(),
                    mini_map.gen_integration.diagnostic({
                        error = "DiagnosticFloatingError",
                        warn = "DiagnosticFloatingWarn",
                        info = "DiagnosticFloatingInfo",
                        hint = "DiagnosticFloatingHint",
                    }),
                    mini_map.gen_integration.gitsigns(),
                },

                -- Symbols used to display data
                symbols = {
                    -- Encode symbols. See `:h MiniMap.config` for specification and
                    -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
                    -- Default: solid blocks with 3x2 resolution.
                    encode = require("mini.map").gen_encode_symbols.block("2x1"), -- '1x2'`, `'2x1'`, `'2x2'`, `'3x2'`
                    -- encode = mini_map.gen_encode_symbols.dot("4x2"), -- 4x2  3x2
                    -- encode = require("mini.map").gen_encode_symbols.shade("1x2"), -- 1x2   2x1
                    -- encode = { "1", "2", "3", "4", resolution = { row encode= 1, col = 2 } },

                    -- Scrollbar parts for view and line. Use empty string to disable any.

                    -- Some suggestions for scrollbar symbols:
                    -- - View-line pairs: '▒' and '█'.
                    -- - Line - '🮚', '▶'.
                    -- - View - '╎', '┋', '┋'.

                    scroll_line = "█", -- █
                    scroll_view = "|", -- ┃
                },

                -- Window options
                window = {
                    -- Whether window is focusable in normal way (with `wincmd` or mouse)
                    focusable = false,

                    -- Side to stick ('left' or 'right')
                    side = "right",

                    -- Whether to show count of multiple integration highlights
                    show_integration_count = true,

                    -- Total width
                    width = 10,

                    -- Value of 'winblend' option
                    winblend = 25,

                    -- Z-index
                    zindex = 10,
                },
            })
            Snacks.toggle
                .new({
                    name = "Mini Map",
                    get = function()
                        return require("mini.map").current.win_id ~= nil
                    end,
                    set = function()
                        require("mini.map").toggle()
                    end,
                })
                :map("<localleader>uM")
        end,
    },
    {
        "andymass/vim-matchup",
        enabled = true,
        event = "BufReadPost",
        init = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    {
        "folke/flash.nvim",
        enabled = false,
    },
    {
        "nvim-mini/mini.diff",
        event = "VeryLazy",
        enabled = true,
        config = function(_, opts)
            require("mini.diff").setup(opts)
            Snacks.toggle
                .new({
                    name = "Mini Diff Overlay",
                    get = function()
                        local data = require("mini.diff").get_buf_data(0)
                        return data ~= nil and data.overlay == true
                    end,
                    set = function()
                        require("mini.diff").toggle_overlay(0)
                    end,
                })
                :map("<localleader>ud")
        end,
        opts = {
            view = {
                style = "sign",
                signs = {
                    add = "▎",
                    change = "▎",
                    delete = "",
                },
            },

            mappings = {
                apply = "",
                reset = "",
                textobject = "",
                goto_first = "",
                goto_prev = "",
                goto_next = "",
                goto_last = "",
            },
        },
    },
    {
        -- this is configured at the bottom of keymaps.lua because its used to modify mappings set by other plugins
        "kiyoon/repeatable-move.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "LazyFile",
        dependencies = {
            {
                -- dep because my config uses repeatable-move
                "kiyoon/repeatable-move.nvim",
                dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
            },
        },
        opts = {
            current_line_blame = false,
            word_diff = false,
            current_line_blame_opts = {
                delay = 0,
            },
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
                end

                local next_hunk = function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end

                local prev_hunk = function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end

                local repeat_move = require("repeatable_move")
                local repeatable_next_hunk, repeatable_prev_hunk = repeat_move.make_repeatable_move_pair(next_hunk, prev_hunk)

                map("n", "]h", repeatable_next_hunk, "Next Hunk")
                map("n", "[h", repeatable_prev_hunk, "Prev Hunk")
                map("n", "]H", function()
                    gs.nav_hunk("last")
                end, "Last Hunk")
                map("n", "[H", function()
                    gs.nav_hunk("first")
                end, "First Hunk")
                map("n", "<localleader>hy", gs.stage_hunk, "Stage Hunk")
                map("x", "<localleader>hy", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage Hunk (Visual)")
                map("n", "<localleader>hr", gs.reset_hunk, "Reset Hunk")
                map("x", "<localleader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset Hunk (Visual)")
                map("n", "<localleader>hY", gs.stage_buffer, "Stage Buffer")

                map("n", "<localleader>hn", gs.undo_stage_hunk, "Undo Stage Hunk")

                map("n", "<localleader>hR", gs.reset_buffer, "Reset Buffer")

                map("n", "<localleader>he", gs.preview_hunk_inline, "Hunk Diff Preview Inline")
                map("n", "<localleader>hh", gs.preview_hunk, "Hunk Diff Hover")
                map("n", "<localleader>hB", function()
                    Snacks.git.blame_line()
                end, "Snacks Blame Line")
                map("n", "<localleader>hb", function()
                    gs.blame_line({ full = true })
                end, "Blame Line")
                Snacks.toggle
                    .new({
                        name = "Blame Buffer",
                        get = function()
                            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                                local name = vim.api.nvim_buf_get_name(buf)
                                if name:match("^gitsigns%-blame:") then
                                    return true
                                end
                            end
                            return false
                        end,
                        set = function(state)
                            if state then
                                gs.blame()
                            else
                                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                                    if vim.api.nvim_buf_get_name(buf):match("^gitsigns%-blame:") then
                                        vim.api.nvim_buf_delete(buf, { force = true })
                                    end
                                end
                            end
                        end,
                    })
                    :map("<localleader>uB")
                Snacks.toggle
                    .new({
                        name = "Inline Blame",
                        get = function()
                            return require("gitsigns.config").config.current_line_blame
                        end,
                        set = function()
                            gs.toggle_current_line_blame()
                        end,
                    })
                    :map("<localleader>ub")
                Snacks.toggle
                    .new({
                        name = "Word Diff",
                        get = function()
                            return require("gitsigns.config").config.word_diff
                        end,
                        set = function()
                            gs.toggle_word_diff()
                        end,
                    })
                    :map("<localleader>uh")

                local function close_gitsigns_diff()
                    vim.cmd("diffoff!")
                    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                        local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
                        if name:match("^gitsigns://") then
                            vim.api.nvim_win_close(win, true)
                            break
                        end
                    end
                end

                local function gitsigns_diff_mode()
                    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                        local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
                        if name:match("^gitsigns://") then
                            -- "~" diffs have the ref after the last colon, e.g. gitsigns://…:~1:filename
                            return name:match("HEAD~") and "tilde" or "head"
                        end
                    end
                    return nil
                end

                map("n", "<localleader>gd", function()
                    local mode = gitsigns_diff_mode()
                    if mode == "head" then
                        close_gitsigns_diff()
                    elseif mode == "tilde" then
                        close_gitsigns_diff()
                        vim.schedule(function()
                            gs.diffthis()
                        end)
                    else
                        gs.diffthis()
                    end
                end, "Diff This (against staged)")

                map("n", "<localleader>gD", function()
                    local mode = gitsigns_diff_mode()
                    if mode == "tilde" then
                        close_gitsigns_diff()
                    elseif mode == "head" then
                        close_gitsigns_diff()
                        vim.schedule(function()
                            gs.diffthis("~")
                        end)
                    else
                        gs.diffthis("~")
                    end
                end, "Diff This (against last commit)")

                map({ "x", "o" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },
    -- {
    --     "hrsh7th/nvim-cmp",
    --     opts = {
    --         experimental = {
    --             ghost_text = false,
    --         },
    --     },
    -- },
    {
        "saghen/blink.cmp",
        version = not vim.g.lazyvim_blink_main and "*",
        build = vim.g.lazyvim_blink_main and "cargo build --release",
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            -- add blink.compat to dependencies
            {
                "saghen/blink.compat",
                optional = true, -- make optional so it's only enabled if any extras need it
                opts = {},
                version = not vim.g.lazyvim_blink_main and "*",
            },
        },
        event = { "InsertEnter", "CmdlineEnter" },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = {
                preset = "default",
            },

            appearance = {
                -- sets the fallback highlight groups to nvim-cmp's highlight groups
                -- useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release, assuming themes add support
                use_nvim_cmp_as_default = false,
                -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            completion = {
                accept = {
                    auto_brackets = {
                        enabled = false,
                    },
                },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                    cycle = { from_top = true, from_bottom = true },
                },
                menu = {
                    auto_show = function()
                        return vim.g.blink_auto_show
                    end,
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                },
                ghost_text = {
                    enabled = false,
                    -- enabled = function()
                    --     if vim.tbl_contains({ "text", "plaintex", "typst", "gitcommit", "markdown" }, vim.bo.filetype) then
                    --         return false
                    --     end
                    --     local node = vim.treesitter.get_node()
                    --     if node then
                    --         local t = node:type()
                    --         if t == "string" or t == "string_content" or t == "string_fragment" or t == "template_string" or t == "comment" or t == "comment_content" or t == "line_comment" or t == "block_comment" then
                    --             return false
                    --         end
                    --     end
                    --     return true
                    -- end,
                },
            },

            -- experimental signature help support
            -- signature = { enabled = true },

            sources = {
                -- adding any nvim-cmp sources here will enable them
                -- with blink.compat
                compat = {},
                default = { "lsp", "path", "snippets", "buffer" },
            },

            cmdline = {
                enabled = true,
                keymap = {
                    preset = "cmdline",
                    -- ["<CR>"] = { "select_and_accept", "fallback" },
                    ["<Right>"] = false,
                    ["<Left>"] = false,
                },
                completion = {
                    list = { selection = { preselect = false } },
                    menu = {
                        -- auto_show = false,
                        auto_show = function(ctx)
                            return vim.fn.getcmdtype() == ":"
                        end,
                    },
                    ghost_text = { enabled = true },
                },
            },

            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept", "show", "show_documentation", "hide_documentation", "fallback" },
                ["<CR>"] = { "fallback" },
                -- ["<C-y>"] = { "select_and_accept" },
                ["<Tab>"] = { "select_next", "select_and_accept", "fallback" }, -- overridden in config() using vim.g.blink_tab_show
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Up>"] = { "fallback" },
                ["<Down>"] = { "fallback" },
                -- ["<Esc>"] = { "cancel", "fallback" },
                ["<Esc>"] = {
                    function(cmp)
                        if cmp.is_visible() then
                            cmp.hide()
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
                            return true
                        end
                    end,
                    "fallback",
                },
            },
        },
        ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
        config = function(_, opts)
            if opts.snippets and opts.snippets.preset == "default" then
                opts.snippets.expand = LazyVim.cmp.expand
            end
            -- setup compat sources
            local enabled = opts.sources.default
            for _, source in ipairs(opts.sources.compat or {}) do
                opts.sources.providers[source] = vim.tbl_deep_extend("force", { name = source, module = "blink.compat.source" }, opts.sources.providers[source] or {})
                if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
                    table.insert(enabled, source)
                end
            end

            -- add ai_accept to <Tab> key
            if not opts.keymap["<Tab>"] then
                if opts.keymap.preset == "super-tab" then -- super-tab
                    opts.keymap["<Tab>"] = {
                        require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
                        LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
                        "fallback",
                    }
                else -- other presets
                    opts.keymap["<Tab>"] = {
                        LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
                        "fallback",
                    }
                end
            end

            -- Unset custom prop to pass blink.cmp validation
            opts.sources.compat = nil

            -- check if we need to override symbol kinds
            for _, provider in pairs(opts.sources.providers or {}) do
                ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
                if provider.kind then
                    local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                    local kind_idx = #CompletionItemKind + 1

                    CompletionItemKind[kind_idx] = provider.kind
                    ---@diagnostic disable-next-line: no-unknown
                    CompletionItemKind[provider.kind] = kind_idx

                    ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
                    local transform_items = provider.transform_items
                    ---@param ctx blink.cmp.Context
                    ---@param items blink.cmp.CompletionItem[]
                    provider.transform_items = function(ctx, items)
                        items = transform_items and transform_items(ctx, items) or items
                        for _, item in ipairs(items) do
                            item.kind = kind_idx or item.kind
                            item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
                        end
                        return items
                    end

                    -- Unset custom prop to pass blink.cmp validation
                    provider.kind = nil
                end
            end

            if vim.g.blink_tab_show == nil then
                vim.g.blink_tab_show = false
            end
            if vim.g.blink_auto_show == nil then
                vim.g.blink_auto_show = true
            end
            opts.keymap["<Tab>"] = {
                function(cmp)
                    if not vim.g.blink_tab_show then
                        return cmp.select_next() or cmp.select_and_accept()
                    end
                    return cmp.select_next() or cmp.show() or cmp.select_and_accept()
                end,
                "fallback",
            }
            require("blink.cmp").setup(opts)

            Snacks.toggle
                .new({
                    name = "Tab Show Blink Completion Menu",
                    get = function()
                        return vim.g.blink_tab_show == true
                    end,
                    set = function(state)
                        vim.g.blink_tab_show = state
                    end,
                })
                :map("<localleader>u<Tab>")
            Snacks.toggle
                .new({
                    name = "Auto Show Blink Completion Menu",
                    get = function()
                        return vim.g.blink_auto_show == true
                    end,
                    set = function(state)
                        vim.g.blink_auto_show = state
                    end,
                })
                :map("<localleader>uy")
        end,
    },
}
