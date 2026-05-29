return {
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
    {
        "dstein64/nvim-scrollview",
        enabled = true,
        config = function()
            require("scrollview").setup({
                excluded_filetypes = { "nerdtree" },
                -- current_only = true,
                -- base = "buffer",
                -- column = 80,
                -- signs_on_startup = { "all" },
                -- diagnostics_severities = { vim.diagnostic.severity.ERROR },
            })
        end,
    },
    {
        "lewis6991/satellite.nvim",
        -- event = "VeryLazy",
        enabled = false,
        -- lazy = false,
        config = function(_, opts)
            require("satellite").setup({
                current_only = false,
                winblend = 75,
                zindex = 40,
                excluded_filetypes = {},
                width = 2,
                handlers = {
                    cursor = {
                        enable = false,
                        -- Supports any number of symbols
                        symbols = { "⎺", "⎻", "⎼", "⎽" },
                        -- symbols = { "⎻", "⎼" },
                        -- Highlights:
                        -- - SatelliteCursor (default links to NonText
                    },
                    search = {
                        enable = true,
                        -- Highlights:
                        -- - SatelliteSearch (default links to Search)
                        -- - SatelliteSearchCurrent (default links to SearchCurrent)
                    },
                    diagnostic = {
                        enable = true,
                        signs = {
                            error = { LazyVim.config.icons.diagnostics.Error },
                            warn = { LazyVim.config.icons.diagnostics.Warn },
                            info = { LazyVim.config.icons.diagnostics.Info },
                            hint = { LazyVim.config.icons.diagnostics.Hint },
                        },
                        min_severity = vim.diagnostic.severity.HINT,
                        -- Highlights:
                        -- - SatelliteDiagnosticError (default links to DiagnosticError)
                        -- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
                        -- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
                        -- - SatelliteDiagnosticHint (default links to DiagnosticHint)
                    },
                    gitsigns = {
                        enable = true,
                        signs = { -- can only be a single character (multibyte is okay)
                            add = "+",
                            change = "│",
                            delete = "-",
                            -- add = "│",
                            -- change = "│",
                            -- delete = "-",
                        },
                        -- Highlights:
                        -- SatelliteGitSignsAdd (default links to GitSignsAdd)
                        -- SatelliteGitSignsChange (default links to GitSignsChange)
                        -- SatelliteGitSignsDelete (default links to GitSignsDelete)
                    },
                    marks = {
                        enable = false,
                        show_builtins = false, -- shows the builtin marks like [ ] < >
                        key = "m",
                        -- Highlights:
                        -- SatelliteMark (default links to Normal)
                    },
                    quickfix = {
                        signs = { "-", "=", "≡" },
                        -- Highlights:
                        -- SatelliteQuickfix (default links to WarningMsg)
                    },
                },
            })
            Snacks.toggle
                .new({
                    name = "Satellite",
                    get = function()
                        return require("satellite.view").enabled()
                    end,
                    set = function(state)
                        local view = require("satellite.view")
                        if state then
                            view.enable()
                        else
                            view.disable()
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
                :map("<localleader>un")
        end,
    },
    {
        "Isrothy/neominimap.nvim",
        version = "v3.x.x",
        enabled = true,
        lazy = false, -- NOTE: NO NEED to Lazy load
        -- Optional. You can also set your own keybindings
        keys = {
            -- Global Minimap Controls
            { "<localleader>uN", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
            -- { "<localleader>Um", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
            -- { "<localleader>nc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
            -- { "<localleader>UM", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },

            -- Window-Specific Minimap Controls
            -- { "<localleader>nwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
            -- { "<localleader>nwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
            -- { "<localleader>nwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
            -- { "<localleader>nwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },

            -- Tab-Specific Minimap Controls
            -- { "<localleader>ntt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
            -- { "<localleader>ntr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
            -- { "<localleader>nto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
            -- { "<localleader>ntc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },

            -- Buffer-Specific Minimap Controls
            -- { "<localleader>nbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
            -- { "<localleader>nbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
            -- { "<localleader>nbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
            -- { "<localleader>nbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },

            ---Focus Controls
            -- { "<localleader>nf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
            -- { "<localleader>nu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
            -- { "<localleader>ns", "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
        },
        init = function()
            -- The following options are recommended when layout == "float"
            vim.opt.wrap = false
            vim.opt.sidescrolloff = 36 -- Set a large value

            --- Put your configuration here

            vim.g.neominimap = {
                auto_enable = false,
                -- layout = "split",
                exclude_filetypes = {
                    "help",
                    "bigfile", -- For Snacks.nvim
                },
                exclude_buftypes = {
                    "nofile",
                    "nowrite",
                    "quickfix",
                    "terminal",
                    "prompt",
                },
                -- How many columns a dot should span
                x_multiplier = 4, ---@type integer

                -- How many rows a dot should span
                y_multiplier = 3, ---@type integer
                -- How the minimap places the current line vertically.
                -- `"center"`  -> pins the line to the viewport middle (window-relative).
                -- `"percent"` -> maps line index / total lines to minimap height (file-relative).
                -- Note: here "center" means the middle of the **minimap window**, not "center of the file".
                -- current_line_position = "center", ---@type Neominimap.Config.CurrentLinePosition
                current_line_position = "percent", ---@type Neominimap.Config.CurrentLinePosition
                --- Used when `layout` is set to `float`
                float = {
                    minimap_width = 18, ---@type integer

                    --- If set to nil, there is no maximum height restriction
                    --- @type integer
                    max_minimap_height = nil,

                    margin = {
                        right = 0, ---@type integer
                        top = 0, ---@type integer
                        bottom = 0, ---@type integer
                    },
                    z_index = 1, ---@type integer

                    --- Border style of the floating window.
                    --- Accepts all usual border style options (e.g., "single", "double")
                    --- @type string | string[] | [string, string][]
                    window_border = vim.fn.has("nvim-0.11") == 1 and vim.o.winborder or "single",

                    -- When true, the floating window will be recreated when you close it.
                    -- When false, the minimap will be disabled for the current tab when you close the minimap window.
                    persist = true, ---@type boolean
                },
                git = {
                    enabled = true,
                },
                mini_diff = {
                    enabled = false,
                },
                search = {
                    enabled = true,
                },
                mark = {
                    enabled = false,
                },
            }
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
        "lewis6991/gitsigns.nvim",
        event = "LazyFile",
        opts = {
            current_line_blame = false,
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

      -- stylua: ignore start
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
      map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
      map({ "n", "x" }, "<localleader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "x" }, "<localleader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<localleader>hS", gs.stage_buffer, "Stage Buffer")
      map("n", "<localleader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<localleader>hR", gs.reset_buffer, "Reset Buffer")
      map("n", "<localleader>he", gs.preview_hunk_inline, "Hunk Diff Preview Inline")
      map("n", "<localleader>hh", gs.preview_hunk, "Hunk Diff Hover")
      map("n", "<localleader>hB", function() Snacks.git.blame_line() end, "Snacks Blame Line")
      map("n", "<localleader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
      Snacks.toggle
        .new({
          name = "Blame Buffer",
          get = function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local name = vim.api.nvim_buf_get_name(buf)
              if name:match("^gitsigns%-blame:") then return true end
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
          get = function() return require("gitsigns.config").config.current_line_blame end,
          set = function() gs.toggle_current_line_blame() end,
        })
        :map("<localleader>ub")

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
          vim.schedule(function() gs.diffthis() end)
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
          vim.schedule(function() gs.diffthis("~") end)
        else
          gs.diffthis("~")
        end
      end, "Diff This (against last commit)")

      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
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
                        enabled = true,
                    },
                },
                list = {
                    selection = {
                        preselect = true,
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
                ["<C-y>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
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
