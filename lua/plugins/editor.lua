return {
    {
        "stevearc/quicker.nvim",
        enabled = false,
        ft = "qf",
        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {},
        keys = {
            {
                "<localleader>kq",
                function()
                    require("quicker").toggle()
                end,
                desc = "Toggle quicker quickfix",
            },
            {
                "<localleader>kw",
                function()
                    require("quicker").toggle({ loclist = true })
                end,
                desc = "Toggle quicker loclist",
            },
            -- {
            --     ">",
            --     function()
            --         require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            --     end,
            --     desc = "Expand quickfix context",
            -- },
            -- {
            --     "<",
            --     function()
            --         require("quicker").collapse()
            --     end,
            --     desc = "Collapse quickfix context",
            -- },
        },
    },
    {
        "Darazaki/indent-o-matic",
        opts = {
            max_lines = 2048,
            standard_widths = { 2, 4 },
            skip_multiline = false, -- Skip multi-line comments and strings (more accurate detection but less performant)
        },
    },
    {
        "martindur/zdiff.nvim",
        cmd = "Zdiff",
        opts = {
            -- Whether files are expanded by default
            default_expanded = false,

            -- Default branch for toggle_mode (m key)
            default_branch = "main",

            -- Keymap bindings (defaults)
            keymaps = {
                goto_file = "o",
                toggle = "<Tab>",
                close = "q",
                refresh = "R",
                toggle_mode = "m",
                help = "?",
                yank_ref = "gy",
            },

            -- Icons for UI elements
            icons = {
                collapsed = "",
                expanded = "",
                added = "+",
                deleted = "-",
                modified = "~",
            },

            -- Syntax highlighting strategy
            syntax = {
                -- "projection" parses old/new full-file snapshots and projects
                -- captures onto unified diff lines. "hunk" keeps legacy behavior.
                mode = "projection",
                -- Skip projection when either old/new source exceeds this many lines.
                -- 0 means unlimited.
                max_lines = 8000,
            },
        },
        keys = {
            {
                "<localleader>gf",
                function()
                    require("zdiff").open()
                end,
                desc = "Zdiff (uncommitted)",
            },
            {
                "<localleader>gF",
                function()
                    require("zdiff").open("main")
                end,
                desc = "Zdiff (vs main)",
            },
        },
    },
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
        "nvim-mini/mini.files",
        enabled = false,
        -- lazy = true,
        opts = {
            windows = {
                preview = true,
                width_focus = 30,
                width_preview = 50,
            },
            options = {
                use_as_default_explorer = false,
            },
        },
        keys = {
            {
                "<localleader>wf",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
                end,
                desc = "Open mini.files (Directory of Current File)",
            },
            {
                "<localleader>wF",
                function()
                    require("mini.files").open(vim.uv.cwd(), true)
                end,
                desc = "Open mini.files (cwd)",
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
            picker = {
                enabled = true,
                ui_select = true,
                -- live = true,
                -- auto_confirm = true, -- Automatically jump if there is only one item
                -- matcher = {
                --     fuzzy = true,
                --     smartcase = true,
                --     filename_bonus = true,
                -- },
                matcher = {
                    fuzzy = true,
                    smartcase = true,
                    filename_bonus = true,
                },
                -- layout = { preset = "vertical", layout = { width = 0.95, height = 0.95 } },

                layouts = {
                    explorer_sidebar = {
                        preset = "left",
                    },
                    explorer_float_center_vertical = {
                        layout = {
                            backdrop = false,
                            width = 0.99,
                            min_width = 80,
                            height = 0.99,
                            min_height = 30,
                            box = "vertical",
                            border = true,
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom", wo = { winhighlight = "NormalFloat:Normal" } },
                            { win = "list", border = "none", wo = { winhighlight = "NormalFloat:NormalNC" } },
                            { win = "preview", title = "{preview}", height = 0.4, border = "top", wo = { winhighlight = "NormalFloat:NormalNC" } },
                        },
                    },
                    explorer_float_center_horizontal = {
                        layout = {
                            box = "horizontal",
                            width = 0.99,
                            min_width = 120,
                            height = 0.99,
                            {
                                box = "vertical",
                                border = true,
                                title = "{title} {live} {flags}",
                                { win = "input", height = 1, border = "bottom", wo = { winhighlight = "NormalFloat:Normal" } },
                                { win = "list", border = "none", wo = { winhighlight = "NormalFloat:NormalNC" } },
                            },
                            { win = "preview", title = "{preview}", border = true, width = 0.525, wo = { winhighlight = "NormalFloat:NormalNC" } },
                        },
                    },
                    explorer_float_center_dropdown = {
                        layout = {
                            backdrop = false,
                            row = 1,
                            width = 0.99,
                            min_width = 80,
                            height = 0.99,
                            border = "none",
                            box = "vertical",
                            { win = "preview", title = "{preview}", height = 0.4, border = true, wo = { winhighlight = "NormalFloat:NormalNC" } },
                            {
                                box = "vertical",
                                border = true,
                                title = "{title} {live} {flags}",
                                title_pos = "center",
                                { win = "input", height = 1, border = "bottom", wo = { winhighlight = "NormalFloat:Normal" } },
                                { win = "list", border = "none", wo = { winhighlight = "NormalFloat:NormalNC" } },
                            },
                        },
                    },
                    explorer_float_center = {
                        cycle = true,
                        preset = function()
                            -- return "explorer_float_center_dropdown"
                            -- return vim.o.columns >= 120 and "explorer_float_center_horizontal" or "explorer_float_center_vertical"
                            return vim.o.columns >= 120 and "explorer_float_center_horizontal" or "explorer_float_center_dropdown"
                        end,
                    },
                    stacked = {
                        preset = "vertical",
                        layout = {
                            backdrop = true,
                            width = 0.9,
                            min_width = 80,
                            height = 0.9,
                            min_height = 30,
                            box = "vertical",
                            border = true,
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                            -- { win = "input", height = 1, border = "bottom" },
                            -- { win = "list", border = "none" },
                            -- { win = "preview", title = "{preview}", height = 0.45, border = "top" },
                            { win = "input", height = 1, border = "bottom", wo = { winhighlight = "NormalFloat:Normal" } },
                            { win = "list", border = "none", wo = { winhighlight = "NormalFloat:NormalNC" } },
                            { win = "preview", title = "{preview}", height = 0.45, border = "top", wo = { winhighlight = "NormalFloat:NormalNC" } },
                        },
                    },
                    large_preview_vertical = {
                        layout = {
                            backdrop = true,
                            row = 1,
                            width = 0.95,
                            height = 0.93,
                            box = "vertical",
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            wo = { winhighlight = "NormalFloat:NormalNC" },
                            -- { win = "input", height = 1, border = "bottom" },
                            -- { win = "list", border = "none" },
                            -- { win = "preview", title = "{preview}", height = 0.75, border = "top" },
                            { win = "input", height = 1, border = "bottom", wo = { winhighlight = "NormalFloat:Normal" } },
                            { win = "list", border = "none", wo = { winhighlight = "NormalFloat:NormalNC" } },
                            { win = "preview", title = "{preview}", height = 0.75, border = "top", wo = { winhighlight = "NormalFloat:NormalNC" } },
                        },
                    },
                    large_preview_horizontal = {
                        layout = {
                            box = "horizontal",
                            backdrop = true,
                            row = 1,
                            width = 0.95,
                            min_width = 120,
                            height = 0.93,
                            wo = { winhighlight = "NormalFloat:NormalNC" },
                            {
                                box = "vertical",
                                border = true,
                                title = "{title} {live} {flags}",
                                { win = "input", height = 1, border = "bottom", wo = { winhighlight = "NormalFloat:NormalNC" } },
                                { win = "list", border = "none", wo = { winhighlight = "NormalFloat:NormalNC" } },
                            },
                            { win = "preview", title = "{preview}", border = true, width = 0.5, wo = { winhighlight = "NormalFloat:NormalNC" } },
                        },
                    },
                    large_preview = {
                        cycle = true,
                        preset = function()
                            return vim.o.columns >= 120 and "large_preview_horizontal" or "large_preview_vertical"
                        end,
                    },
                },
                layout = {
                    preset = "large_preview",
                },
                sources = {
                    explorer = {
                        layout = "explorer_float_center",
                        auto_close = true,
                        win = {
                            list = {
                                keys = {
                                    ["o"] = "confirm",
                                    ["<C-s>"] = "explorer_open", -- open with system application
                                    ["<2-LeftMouse>"] = false,
                                    ["<C-o>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                                    ["s"] = "edit_split",
                                    ["S"] = "edit_vsplit",
                                    ["<c-y>"] = { "yank_relative_path", mode = { "n", "i" } },
                                    ["<c-z>"] = { "yank_absolute_path", mode = { "n", "i" } },
                                    ["<C-e>"] = { "focus_preview", mode = { "n", "i" } },
                                    ["<C-l>"] = { "toggle_focus", mode = { "n", "i" } },
                                    ["<C-t>"] = "picker_grep",
                                    ["<localleader>y"] = "yank_relative_path",
                                    ["<localleader>Y"] = "yank_absolute_path",
                                    ["R"] = "explorer_git_rename",
                                },
                            },
                        },
                    },
                    commands = {
                        focus = "list", -- Ensure focus starts on the results list
                    },
                    buffers = {
                        focus = "list", -- Ensure focus starts on the results list
                    },
                    search_history = {
                        focus = "list", -- Ensure focus starts on the results list
                    },
                    select = {
                        focus = "list", -- Ensure focus starts on the results list
                        -- on_show = function(picker)
                        --     vim.schedule(function()
                        --         vim.cmd.stopinsert() -- Drop out of insert mode immediately
                        --     end)
                        -- end,
                    },
                    lsp_references = {
                        layout = "large_preview",
                        -- on_show = function(picker)
                        --     vim.schedule(function()
                        --         vim.cmd.stopinsert() -- Drop out of insert mode immediately
                        --     end)
                        -- end,
                        focus = "list", -- Ensure focus starts on the results list
                        auto_confirm = true, -- Automatically jump if there is only one item
                        live = false, -- global `live = true` above blocks auto_confirm; opt this source out
                        transform = function(item, ctx)
                            -- dont have import statements show up as references in typescript
                            -- (handles both single-line and multi-line `import { ... } from '...';`)
                            if vim.g.snacks_filter_import_refs == false then
                                return item
                            end
                            if not (item.file and item.pos) then
                                return item
                            end

                            local lnum, col = item.pos[1], item.pos[2]
                            local line = item.line
                            if not line then
                                return item
                            end

                            -- word under the reference position, used to confirm it's actually
                            -- one of the named imports (not just any line that looks import-ish)
                            local pre = line:sub(1, col):match("[%w_$]+$") or ""
                            local post = line:sub(col + 1):match("^[%w_$]+") or ""
                            local word = pre .. post
                            if word == "" then
                                return item
                            end

                            local lines
                            if item.buf and vim.api.nvim_buf_is_loaded(item.buf) then
                                lines = vim.api.nvim_buf_get_lines(item.buf, 0, -1, false)
                            else
                                lines = vim.fn.readfile(item.file)
                            end

                            local window = 25
                            local start_idx
                            for i = lnum, math.max(1, lnum - window), -1 do
                                if lines[i] and lines[i]:match("^%s*import%s") then
                                    start_idx = i
                                    break
                                end
                            end
                            if not start_idx then
                                return item
                            end

                            local end_idx
                            for i = lnum, math.min(#lines, lnum + window) do
                                if lines[i] and lines[i]:match("from%s+['\"][^'\"]+['\"]%s*;?%s*$") then
                                    end_idx = i
                                    break
                                end
                            end
                            if not end_idx then
                                return item
                            end

                            local block = table.concat(lines, " ", start_idx, end_idx)
                            -- explicit shape required: import [type] { name, name, ... } from '...';
                            local names = block:match("^%s*import%s+type%s*{(.-)}%s*from%s+['\"][^'\"]+['\"]%s*;?%s*$") or block:match("^%s*import%s*{(.-)}%s*from%s+['\"][^'\"]+['\"]%s*;?%s*$")
                            if not names then
                                return item
                            end

                            for name in names:gmatch("[%w_$]+") do
                                if name == word then
                                    return false
                                end
                            end

                            return item
                        end,
                    },
                    lsp_definitions = {
                        layout = "large_preview",
                        focus = "list", -- Ensure focus starts on the results list
                        auto_confirm = true, -- Automatically jump if there is only one item
                        live = false, -- global `live = true` above blocks auto_confirm; opt this source out
                    },

                    lsp_code_actions = {
                        transform = function(item, ctx)
                            --  1. Disable @typescript-eslint/no-unsafe-assignment for this line [eslint]
                            --  2. Disable @typescript-eslint/no-unsafe-assignment for the entire file [eslint]
                            --  3. Show documentation for @typescript-eslint/no-unsafe-assignment [eslint]
                            --  4. Disable @typescript-eslint/no-unsafe-call for this line [eslint]
                            --  5. Disable @typescript-eslint/no-unsafe-call for the entire file [eslint]
                            --  6. Show documentation for @typescript-eslint/no-unsafe-call [eslint]
                            --  7. Update import from "./canonicalPath" [vtsls]
                            --  8. Add missing function declaration 'unparseMemberRef' [vtsls]
                            --  9. Convert default export to named export [vtsls]
                            -- 10. Convert named export to default export [vtsls]
                            -- 11. Convert namespace import to named imports [vtsls]
                            -- 12. Convert named imports to default import [vtsls]
                            -- 13. Convert named imports to namespace import [vtsls]
                            -- 14. Extract to typedef [vtsls]
                            -- 15. Extract to type alias [vtsls]
                            -- 16. Extract to interface [vtsls]
                            --
                            -- item.text holds the title/description of the code action
                            if item.text and item.text:lower():match("update.*import") then
                                item.score = 10000 -- Forces the item to stick to the top
                            end
                            return item
                        end,
                    },
                },
                actions = {
                    yank_relative_path = function(picker, item)
                        item = item or picker:current()
                        local path = item and Snacks.picker.util.path(item)
                        if not path then
                            return
                        end
                        local rel = vim.fn.fnamemodify(path, ":.")
                        vim.fn.setreg("+", rel)
                        Snacks.notify.info("Copied: " .. rel)
                    end,
                    yank_absolute_path = function(picker, item)
                        item = item or picker:current()
                        local path = item and Snacks.picker.util.path(item)
                        if not path then
                            return
                        end
                        vim.fn.setreg("+", path)
                        Snacks.notify.info("Copied: " .. path)
                    end,
                    explorer_git_rename = function(picker, item)
                        require("custom-utils.explorer_git_rename").rename(picker, item)
                    end,
                    qflist = function(picker)
                        -- Get currently selected items (or all filtered items if none are marked)
                        local sel = picker:selected()
                        local items = #sel > 0 and sel or picker:items()

                        -- Convert snacks picker items into standard Neovim quickfix items
                        local qf_items = {}
                        for _, item in ipairs(items) do
                            local filename = Snacks.picker.util.path(item)
                            if filename then
                                table.insert(qf_items, {
                                    filename = filename,
                                    lnum = item.pos and item.pos[1] or 1,
                                    col = item.pos and item.pos[2] + 1 or 1,
                                    text = item.line or item.comment or item.text or "",
                                })
                            end
                        end

                        -- Close the picker before notifying so the message isn't hidden
                        picker:close()

                        -- Populate the quickfix list without opening the window
                        if #qf_items > 0 then
                            vim.fn.setqflist(qf_items, "r")
                            Snacks.notify.info(string.format("Added %d items to the quickfix list", #qf_items))
                        else
                            Snacks.notify.warn("No valid items to add to the quickfix list")
                        end
                    end,
                },
                win = {
                    -- Apply overrides globally across all inner picker windows
                    input = {
                        keys = {
                            ["o"] = "confirm",
                            ["<C-s>"] = "explorer_open", -- open with system application
                            ["<2-LeftMouse>"] = false,
                            ["<Esc>"] = { "close", mode = { "n", "i" } },
                            ["<C-o>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                            ["s"] = "edit_split",
                            ["S"] = "edit_vsplit",
                            ["P"] = { "toggle_preview", mode = { "n", "i" } },
                            ["<c-y>"] = { "yank_relative_path", mode = { "n", "i" } },
                            ["<c-z>"] = { "yank_absolute_path", mode = { "n", "i" } },
                            ["<localleader>y"] = "yank_relative_path",
                            ["<localleader>Y"] = "yank_absolute_path",
                            ["<C-t>"] = { "picker_grep", mode = { "n", "i" } },
                            ["<C-e>"] = { "focus_preview", mode = { "n", "i" } },
                            ["<C-l>"] = { "toggle_focus", mode = { "n", "i" } },
                            ["<C-x>"] = {
                                function(picker)
                                    vim.cmd("stopinsert")
                                end,
                                mode = { "i" },
                                desc = "Escape to normal mode",
                            },
                        },
                    },
                    list = {
                        keys = {
                            ["<2-LeftMouse>"] = false,
                            ["P"] = { "toggle_preview", mode = { "n", "i" } },
                            ["<C-e>"] = { "focus_preview", mode = { "n", "i" } },
                            ["<C-l>"] = { "toggle_focus", mode = { "n", "i" } },
                        },
                    },
                    preview = {
                        keys = {
                            ["<2-LeftMouse>"] = false,
                            ["P"] = { "toggle_preview", mode = { "n", "i" } },
                            ["i"] = "focus_input",
                            ["a"] = "focus_list",
                        },
                    },
                },
            },
            -- statuscolumn = { enabled = false },
            ---@class snacks.terminal.Config
            terminal = { enabled = false },
            ---@class snacks.input.Config
            input = { enabled = false },
            ---@class snacks.explorer.Config
            explorer = { enabled = true, replace_netrw = true },
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

        keys = {
            {
                "<localleader>wA",
                function()
                    -- Snacks.explorer.reveal({ cwd = LazyVim.root() })
                    Snacks.explorer({ cwd = LazyVim.root(), layout = "explorer_sidebar" })
                end,
                desc = "Explorer Snacks (root dir)",
            },
            {
                "<localleader>wa",
                function()
                    Snacks.explorer({ layout = "explorer_sidebar" })
                    -- Snacks.explorer()
                end,
                desc = "Explorer Snacks (cwd)",
            },
            {
                "<localleader>e",
                function()
                    local explorer = Snacks.picker.get({ source = "explorer" })[1]
                    if explorer then
                        explorer:close()
                    else
                        Snacks.explorer.reveal({ layout = "explorer_float_center" })
                    end
                end,
                desc = "Explorer Snacks Float (cwd)",
            },
            {
                "<localleader>E",
                function()
                    local explorer = Snacks.picker.get({ source = "explorer" })[1]
                    if explorer then
                        explorer:close()
                    else
                        Snacks.explorer.reveal({ cwd = LazyVim.root(), layout = "explorer_float_center" })
                    end
                end,
                desc = "Explorer Snacks Float (root dir)",
            },
            {
                "<localleader>wf",
                function()
                    local explorer = Snacks.picker.get({ source = "explorer" })[1]
                    if explorer then
                        explorer:close()
                    else
                        -- Get the full path of the parent directory of the current active file
                        local current_file_dir = vim.fn.expand("%:p:h")

                        -- If it's a valid directory, use it as the explorer root and follow the file
                        if vim.fn.isdirectory(current_file_dir) == 1 then
                            Snacks.explorer({
                                cwd = current_file_dir,
                                layout = "explorer_float_center",
                                follow_file = true,
                            })
                        else
                            -- Fallback default if you are on an empty/unnamed buffer
                            Snacks.explorer({ layout = "explorer_float_center", follow_file = true })
                        end
                        -- Snacks.explorer({ layout = "explorer_float_center", follow_file = true })
                    end
                end,
                desc = "Explorer Snacks Float (current file)",
            },
            -- +------------------------------------+---------------------------------------+-----------------------------------------------+
            -- | FzfLua Command                     | Snacks Picker Equivalent              | Description                                   |
            -- +------------------------------------+---------------------------------------+-----------------------------------------------+
            -- | FzfLua.lsp_references()            | Snacks.picker.lsp_references()        | Find all references under cursor              |
            -- | FzfLua.lsp_definitions()           | Snacks.picker.lsp_definitions()       | Jump to definition                            |
            -- | FzfLua.lsp_typedefs()              | Snacks.picker.lsp_typedefs()          | Jump to type definition                       |
            -- | FzfLua.lsp_implementations()       | Snacks.picker.lsp_implementations()   | Jump to implementation                        |
            -- | FzfLua.lsp_document_symbols()      | Snacks.picker.lsp_symbols()           | Filter treesitter/LSP symbols in buffer       |
            -- | FzfLua.lsp_workspace_symbols()     | Snacks.picker.lsp_workspace_symbols() | Search symbols across workspace               |
            -- | FzfLua.diagnostics_document()      | Snacks.picker.diagnostics()           | Buffer diagnostics (errors/warnings)          |
            -- | FzfLua.diagnostics_workspace()     | Snacks.picker.diagnostics()           | Workspace-wide diagnostics                    |
            -- | (None)                             | Snacks.picker.explorer()              | Built-in sidebar file tree explorer           |
            -- | (None)                             | Snacks.picker.clipboards()            | Search system clipboard history histories     |
            -- |-(None)                             | Snacks.picker.lazy()                  | Search installed lazy.nvim plugins / specs    |
            -- +------------------------------------+---------------------------------------+-----------------------------------------------+
            -- stylua: ignore start
            { "<localleader>fb", function() Snacks.picker.buffers() end, desc = "fuzzy buffers", },
            -- { "<localleader>fb", function() Snacks.picker.git_grep() end, desc = "fuzzy buffers", },
            { "<localleader>fd", function() Snacks.picker.git_files() end, desc = "fuzzy git files", },
            { "<localleader>fD", function() Snacks.picker.git_diff() end, desc = "fuzzy git diff", },
            { "<localleader>fe", function() Snacks.picker.files() end, desc = "fuzzy fuzzy files", },
            { "<localleader>ff", function() Snacks.picker.resume() end, desc = "fuzzy resume", },
            { "<localleader>fj", function() Snacks.picker.jumps({ focus = "list" }) end, desc = "fuzzy jumps", },
            { "<localleader>fl", function() Snacks.picker.lines({ args = { "--fixed-strings" }, }) end, desc = "fuzzy lines text search", },
            { "<localleader>fL", function() Snacks.picker.lines() end, desc = "fuzzy lines grep search", },
            { "<localleader>fo", function() Snacks.picker.lsp_workspace_symbols() end, desc = "fuzzy workspace symbols", },
            { "<localleader>fO", function() Snacks.picker.lsp_symbols() end, desc = "fuzzy symbols", },
            { "<localleader>fP", function() Snacks.picker.projects({ focus = "list" }) end, desc = "fuzzy projects", },
            { "<localleader>fq", function() Snacks.picker.qflist({ focus = "list" }) end, desc = "fuzzy quickfix", },
            { "<localleader>fQ", function() Snacks.picker.loclist({ focus = "list" }) end, desc = "fuzzy loclist", },
            { "<localleader>fr", function() Snacks.picker.recent() end, desc = "fuzzy recent files", },
            { "<localleader>fs", function() Snacks.picker.grep({ args = { "--fixed-strings" }, }) end, desc = "fuzzy text search", },
            { "<localleader>fS", function() Snacks.picker.grep() end, desc = "fuzzy grep search", },
            { "<localleader>ft", function() require('custom-utils.snacks_tab_picker').tabs_picker() end, desc = "fuzzy tab", },
            { "<C-q>", function() require('custom-utils.snacks_tab_picker').tabs_picker() end, desc = "fuzzy tab", },
            { "<localleader>fw", function() Snacks.picker.grep_word() end, desc = "fuzzy word search", },
            { "<localleader>f'", function() Snacks.picker.marks({ focus = "list" }) end, desc = "fuzzy marks", },
            { "<localleader>f<space>", function() Snacks.picker.smart() end, desc = "fuzzy smart", },

            { "<localleader>ai", function() Snacks.picker.icons() end, desc = "fuzzy icons", },

            { "<localleader>na", function() Snacks.picker.autocmds() end, desc = "fuzzy autocmds", },
            { "<localleader>nc", function() Snacks.picker.colorschemes({ focus = "list" }) end, desc = "fuzzy colorschemes", },
            { "<localleader>nC", function() Snacks.picker.highlights() end, desc = "fuzzy color highlights", },
            { "<localleader>nh", function() Snacks.picker.help() end, desc = "fuzzy help", },
            { "<localleader>nn", function() Snacks.picker.notifications({ focus = "list" }) end, desc = "fuzzy notifications", },
            { "<localleader>no", function() Snacks.picker.treesitter() end, desc = "fuzzy treesitter", },
            { "<localleader>np", function() Snacks.picker.commands({ focus = "input" }) end, desc = "fuzzy commands picker", },
            { "<localleader>nP", function() Snacks.picker.pickers({ focus = "list" }) end, desc = "fuzzy snacks pickers", },
            { "<localleader>nu", function() Snacks.picker.undo({ focus = "list" }) end, desc = "fuzzy undo", },
            { "<localleader>n/", function() Snacks.picker.search_history() end, desc = "fuzzy search history", },
            { "<localleader>n?", function() Snacks.picker.keymaps() end, desc = "fuzzy keymaps", },
            { "<localleader>n:", function() Snacks.picker.command_history() end, desc = "fuzzy command history", },
            { '<localleader>n"', function() Snacks.picker.registers() end, desc = "fuzzy registers", },
            { 'z=', function() Snacks.picker.spelling({ focus = "list" }) end, desc = "fuzzy spelling", },

            { "<localleader>gb", function() Snacks.picker.git_log_line({ on_show = function() vim.cmd.stopinsert() end, }) end, desc = "fuzzy git blame line", },
            { "<localleader>gc", function() Snacks.picker.git_log({ on_show = function() vim.cmd.stopinsert() end, }) end, desc = "fuzzy git log", },
            { "<localleader>gC", function() Snacks.picker.git_log_file({ on_show = function() vim.cmd.stopinsert() end, }) end, desc = "fuzzy git log file", },
            { "<localleader>gn", function() Snacks.picker.git_branches({ on_show = function() vim.cmd.stopinsert() end, }) end, desc = "fuzzy git branch", },
            { "<localleader>gr", function() Snacks.picker.git_stash({ on_show = function() vim.cmd.stopinsert() end, }) end, desc = "fuzzy git stash", },
            { "<localleader>gs", function() Snacks.picker.git_status({ on_show = function() vim.cmd.stopinsert() end, }) end, desc = "fuzzy git status", },

            -- stylua: ignore end
            {
                "<localleader>uR",
                function()
                    Snacks.toggle
                        .new({
                            name = "Filter Import Statements from LSP References",
                            get = function()
                                return vim.g.snacks_filter_import_refs ~= false
                            end,
                            set = function(state)
                                vim.g.snacks_filter_import_refs = state
                            end,
                        })
                        :toggle()
                end,
                desc = "toggle lsp references import filtering",
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
                :map("<localleader>uM")
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
                :map("<localleader>um")
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
                ["<C-y>"] = { "cancel", "show", "fallback" },
                ["<C-h>"] = { "hide_signature", "show_signature", "fallback" },
                ["<C-k>"] = { "hide_documentation", "show_documentation", "fallback" },
                -- ["<C-j>"] = { "select_and_accept", "fallback" },
                -- ["<CR>"] = { "cancel", "fallback" },
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
