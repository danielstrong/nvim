return {
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
                ["<Esc>"] = { "cancel", "fallback" },
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

            vim.g.blink_tab_show = false
            vim.g.blink_auto_show = true
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
