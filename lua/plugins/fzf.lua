return {
    {
        "ibhagwan/fzf-lua",
        opts = {
            fzf_bin = "sk",
            -- fzf_colors = true,
            oldfiles = {
                include_current_session = true, -- includes current buffer files as oldfiles
            },
            hls = {
                -- normal = "FzfLuaNormal", -- FzfLuaNormal
                -- border = "FloatBorder",
                -- title = "FloatBorder",
                -- title_flags = "CursorLine",
                -- backdrop = "FzfLuaBackdrop",
                -- preview_normal = "FzfLuaPreviewNormal",
                -- preview_border = "FloatBorder",
                -- preview_title = "FloatBorder",
                -- cursor = "FloatBorder",
                -- cursorline = "FloatBorder",
                -- cursorlinenr = "FloatBorder",
                -- search = "FzfLuaSearch",
                -- scrollborder_e = "FloatBorder",
                -- scrollborder_f = "PmenuThumb",
                -- scrollfloat_e = "FloatBorder",
                -- scrollfloat_f = "PmenuThumb",
                -- help_normal = "PmenuThumb",
                -- help_border = "PmenuThumb",
                -- header_bind = "PmenuThumb",
                -- header_text = "PmenuThumb",
                -- path_colnr = "PmenuThumb",
                -- path_linenr = "PmenuThumb",
                -- buf_name = "PmenuThumb",
                -- buf_id = "PmenuThumb",
                -- buf_nr = "PmenuThumb",
                -- buf_linenr = "PmenuThumb",
                -- buf_flag_cur = "PmenuThumb",
                -- buf_flag_alt = "PmenuThumb",
                -- tab_title = "PmenuThumb",
                -- tab_marker = "PmenuThumb",
                -- dir_icon = "PmenuThumb",
                -- dir_part = "PmenuThumb",
                -- file_part = "PmenuThumb",
                -- live_prompt = "PmenuThumb",
                -- live_sym = "PmenuThumb",
                -- cmd_ex = "PmenuThumb",
                -- cmd_buf = "PmenuThumb",
                -- cmd_global = "PmenuThumb",
            },
            winopts = {
                height = 0.95,
                width = 0.95,
                row = 0.35,
                col = 0.50,
                border = "rounded",
                backdrop = 60,
                fullscreen = false,
                treesitter = {
                    enabled = true,
                    fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
                },
                preview = {
                    border = "rounded",
                    wrap = true,
                    hidden = false,
                    vertical = "down:45%",
                    horizontal = "right:60%",
                    layout = "flex",
                    flip_columns = 150,
                    title = true,
                    title_pos = "center",
                    scrollbar = "float",
                    scrolloff = -1,
                    delay = 20,
                    winopts = {
                        number = true,
                        relativenumber = false,
                        cursorline = true,
                        cursorlineopt = "both",
                        cursorcolumn = false,
                        signcolumn = "yes",
                        list = false,
                        foldenable = false,
                        foldmethod = "manual",
                    },
                },
            },
            defaults = {
                -- header = false,
                -- no_header_i = true
                formatter = "path.filename_first",
            },
            fzf_opts = {
                ["--ansi"] = true,
                ["--info"] = "default",
                ["--height"] = "100%",
                ["--layout"] = "reverse",
                ["--border"] = "none",
                ["--highlight-line"] = true,
                ["--algo"] = "skim_v2",
                ["--typos"] = "3",
                ["--case"] = "ignore",
            },
            previewers = {
                cat = { cmd = "cat", args = "-n" },
                bat = { cmd = "bat", args = "--color=always --style=numbers,changes" },
                head = { cmd = "head", args = nil },
                git_diff = {
                    cmd_deleted = "git diff --color HEAD --",
                    cmd_modified = "git diff --color HEAD",
                    cmd_untracked = "git diff --color --no-index /dev/null",
                },
                man = { cmd = "man -c %s | col -bx" },
                builtin = {
                    syntax = true,
                    syntax_limit_l = 0,
                    syntax_limit_b = 1024 * 1024,
                    limit_b = 1024 * 1024 * 10,
                    treesitter = {
                        enabled = true,
                        disabled = {},
                        context = { max_lines = 1, trim_scope = "inner" },
                    },
                    toggle_behavior = "default",
                    extensions = {
                        ["png"] = { "viu", "-b" },
                        ["svg"] = { "chafa", "{file}" },
                        ["jpg"] = { "ueberzug" },
                    },
                    ueberzug_scaler = "cover",
                    render_markdown = { enabled = true, filetypes = { ["markdown"] = true } },
                    snacks_image = { enabled = true, render_inline = true },
                },
                codeaction = { diff_opts = { ctxlen = 3 } },
                codeaction_native = { diff_opts = { ctxlen = 3 } },
            },
            -- config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
            -- config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
            -- config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
            -- config.defaults.keymap.fzf["ctrl-x"] = "jump"
            -- config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
            -- config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
            -- config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
            -- config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

            -- `action`   |alt-Q|        *file-selection-to-loclist*   `builtin`  |ctrl-b|       *preview-page-up*             `builtin`  |f7|           *toggle-preview-ts-ctx*       `fzf`      |ctrl-r|       *toggle-root-dir*
            -- `action`   |alt-c|        *toggle-root-dir*             `builtin`  |ctrl-f|       *preview-page-down*           `builtin`  |f8|           *preview-ts-ctx-dec*          `fzf`      |ctrl-s|       *file-split*
            -- `action`   |alt-f|        *toggle-follow*               `builtin`  |ctrl-i|       *toggle-preview-behavior*     `builtin`  |f9|           *preview-ts-ctx-inc*          `fzf`      |ctrl-t|       *smart-open-with-trouble*
            -- `action`   |alt-h|        *toggle-hidden*               `builtin`  |ctrl-m|       *preview-up*                  `builtin`  |shift-down|   *preview-page-down*           `fzf`      |ctrl-u|       *half-page-up*
            -- `action`   |alt-i|        *toggle-ignore*               `builtin`  |ctrl-n|       *preview-down*                `builtin`  |shift-left|   *preview-reset*               `fzf`      |ctrl-v|       *file-vsplit*
            -- `action`   |alt-q|        *file-selection-to-qf*        `builtin`  |ctrl-o|       *toggle-preview-cw*           `builtin`  |shift-up|     *preview-page-up*             `fzf`      |enter|        *file-edit-or-qf*
            -- `action`   |ctrl-c|       *abort*                       `builtin`  |ctrl-p|       *toggle-preview*              `fzf`      |alt-G|        *last*                        `fzf`      |esc|          *hide*
            -- `action`   |ctrl-r|       *toggle-root-dir*             `builtin`  |ctrl-v|       *toggle-help*                 `fzf`      |alt-Q|        *file-selection-to-loclist*
            -- `action`   |ctrl-s|       *file-split*                  `builtin`  |ctrl-x|       *toggle-preview-wrap*         `fzf`      |alt-a|        *toggle-all*
            -- `action`   |ctrl-t|       *smart-open-with-trouble*     `builtin`  |ctrl-z|       *toggle-fullscreen*           `fzf`      |alt-c|        *toggle-root-dir*
            -- `action`   |ctrl-v|       *file-vsplit*                 `builtin`  |f1|           *toggle-help*                 `fzf`      |alt-g|        *first*
            -- `action`   |enter|        *file-edit-or-qf*             `builtin`  |f2|           *toggle-fullscreen*           `fzf`      |alt-q|        *file-selection-to-qf*
            -- `action`   |esc|          *hide*                        `builtin`  |f3|           *toggle-preview-wrap*         `fzf`      |alt-s|        *toggle*
            -- `builtin`  |alt-esc|      *abort*                       `builtin`  |f4|           *toggle-preview*              `fzf`      |ctrl-a|       *beginning-of-line*
            -- `builtin`  |alt-shift-down| *preview-down*                `builtin`  |f5|           *toggle-preview-cw*           `fzf`      |ctrl-d|       *half-page-down*
            -- `builtin`  |alt-shift-up| *preview-up*                  `builtin`  |f6|           *toggle-preview-behavior*     `fzf`      |ctrl-e|       *end-of-line*
            --
            -- actions = {
            --     files = {
            --         ["ctrl-t"] = require("trouble.sources.fzf").actions.open,
            --     },
            -- },
            keymap = {
                builtin = {
                    ["<M-Esc>"] = "hide",
                    ["<C-y>"] = "toggle-help",
                    ["<C-z>"] = "toggle-fullscreen",
                    ["<C-x>"] = "toggle-preview-wrap",
                    ["<C-p>"] = "toggle-preview",
                    ["<C-o>"] = "toggle-preview-cw",
                    -- ["<C-W>"] = "toggle-preview-behavior",
                    -- ["<C-w>"] = "toggle-preview-ts-ctx",
                    -- ["<C-w>"] = "preview-ts-ctx-dec",
                    -- ["<F9>"] = "preview-ts-ctx-inc",
                    ["<S-Left>"] = "preview-reset",
                    ["<S-down>"] = "preview-page-down",
                    ["<S-up>"] = "preview-page-up",
                    ["<M-S-down>"] = "preview-down",
                    ["<M-S-up>"] = "preview-up",
                },
                fzf = {
                    ["ctrl-u"] = "unix-line-discard",
                    ["ctrl-f"] = "half-page-down",
                    ["ctrl-b"] = "half-page-up",
                    ["ctrl-a"] = "beginning-of-line",
                    ["ctrl-e"] = "end-of-line",
                    ["ctrl-w"] = "toggle-all",
                    ["ctrl-c"] = "toggle",
                    ["alt-g"] = "first",
                    ["alt-G"] = "last",
                    ["shift-down"] = "preview-page-down",
                    ["shift-up"] = "preview-page-up",
                },
            },

            actions = {
                -- Below are the default actions, setting any value in these tables will override
                -- the defaults, to inherit from the defaults change [1] from `false` to `true`
                files = {
                    -- true,        -- uncomment to inherit all the below in your custom config
                    -- Pickers inheriting these actions:
                    --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
                    --   tags, btags, args, buffers, tabs, lines, blines
                    -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
                    -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
                    -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
                    ["enter"] = require("fzf-lua").actions.file_edit_or_qf,
                    ["ctrl-s"] = require("fzf-lua").actions.file_split,
                    ["ctrl-v"] = require("fzf-lua").actions.file_vsplit,
                    ["ctrl-t"] = require("fzf-lua").actions.file_tabedit,
                    ["alt-q"] = require("fzf-lua").actions.file_sel_to_qf,
                    ["alt-w"] = require("fzf-lua").actions.file_sel_to_ll,
                    ["alt-i"] = require("fzf-lua").actions.toggle_ignore,
                    ["alt-h"] = require("fzf-lua").actions.toggle_hidden,
                    ["alt-f"] = require("fzf-lua").actions.toggle_follow,
                    ["alt-t"] = require("trouble.sources.fzf").actions.open,
                },
            },
        },
        keys = (function()
            local function fzf_files()
                require("fzf-lua").files({ cmd = "fd --type f --no-ignore --exclude node_modules --exclude .git" })
            end
            local function fzf_files_path()
                require("fzf-lua").files({
                    ---@diagnostic disable-next-line: assign-type-mismatch
                    formatter = false,
                    cmd = "fd --type f --hidden --no-ignore --exclude node_modules --exclude .git/objects",
                })
            end
            local function fzf_git_changes()
                require("fzf-lua").fzf_exec("git diff --name-only && git ls-files --deleted --others --killed --exclude-standard", { actions = require("fzf-lua").defaults.actions.files, previewer = "builtin" })
            end
            local rg_base = "--fixed-strings --color=always --no-heading --with-filename --line-number --column"
            local function text_search(case_insensitive, query)
                local toggle = function(_, opts)
                    text_search(not case_insensitive, opts.last_query)
                end
                require("fzf-lua").live_grep({
                    rg_opts = case_insensitive and ("--ignore-case " .. rg_base) or rg_base,
                    prompt = case_insensitive and "Text (case-insensitive)> " or "Text (case-sensitive)> ",
                    search = query or "",
                    no_esc = query ~= nil,
                    actions = { ["ctrl-l"] = toggle },
                })
            end
            local function fzf_text_search_live_grep()
                text_search(true)
            end
            local function fzf_text_search_grep()
                require("fzf-lua").grep({ rg_opts = "--fixed-strings --color=always --no-heading --with-filename --line-number --column", prompt = "Text> " })
            end
            -- https://github.com/ibhagwan/fzf-lua
            return {
                { "<localleader>fE", fzf_files, desc = "Fzf Files" },
                { "<localleader>fe", "<cmd>FzfLua files<cr>", desc = "Fzf All files" },
                { "<localleader>fp", fzf_files_path, desc = "Fzf files (path search)" },
                { "<localleader>fD", "<cmd>FzfLua git_diff<cr>", desc = "Fzf Git Diff" },
                { "<localleader>fd", fzf_git_changes, desc = "Fzf Git Changes" },
                { "<localleader>fs", fzf_text_search_live_grep, desc = "Fzf Live Text Search" },
                { "<localleader>fS", fzf_text_search_grep, desc = "Fzf Text Search" },

                { "<localleader>vs", "<cmd>FzfLua grep_visual<cr>", desc = "Fzf Visual Live Text Search", mode = { "n", "x" } },
                { "<localleader>bs", "<cmd>FzfLua grep_curbuf<cr>", desc = "Fzf Buffer Live Text Search" },
                { "<localleader>n/", "<cmd>FzfLua search_history<cr>", desc = "Fzf Search History" },
                { "<localleader>na", "<cmd>FzfLua autocmds<cr>", desc = "Fzf Autocmds" },
                { "<localleader>nt", "<cmd>FzfLua tmux_buffers<cr>", desc = "Fzf Tmux Buffers" },
                { "<localleader>no", "<cmd>FzfLua treesitter<cr>", desc = "Fzf Treesitter" },
                { "<localleader>nh", "<cmd>FzfLua helptags<cr>", desc = "Fzf Helptags" },
                { "<localleader>nH", "<cmd>FzfLua manpages<cr>", desc = "Fzf Manpages" },
                { "<localleader>n:", "<cmd>FzfLua command_history<cr>", desc = "Fzf Command History" },
                { "<localleader>nc", "<cmd>FzfLua colorschemes<cr>", desc = "Fzf Color Schemes" },
                { "<localleader>nC", "<cmd>FzfLua highlights<cr>", desc = "Fzf Color Highlights" },
                { "<localleader>ny", "<cmd>FzfLua tagstacks<cr>", desc = "Fzf Tag Stack" },
                { '<localleader>n"', "<cmd>FzfLua registers<cr>", desc = "Fzf Registers" },
                { "<localleader>np", "<cmd>FzfLua commands<cr>", desc = "Fzf Commands" },
                { "<localleader>nP", "<cmd>FzfLua builtin<cr>", desc = "Fzf Builtin" },
                { "<localleader>n?", "<cmd>FzfLua keymaps<cr>", desc = "Fzf Keymaps" },
                { "<localleader>z=", "<cmd>FzfLua spell_suggest<cr>", desc = "FZF Spell Suggest" },
                { "<localleader>fj", "<cmd>FzfLua jumps<cr>", desc = "Fzf Jumps" },
                { "<localleader>f*", "<cmd>FzfLua grep_cword<cr>", desc = "Fzf Grep Cword" },
                { "<localleader>f'", "<cmd>FzfLua marks<cr>", desc = "Fzf Marks" },
                { "<localleader>fl", "<cmd>FzfLua blines<cr>", desc = "Fzf Lines in Buffer" },
                { "<localleader>fL", "<cmd>FzfLua lines<cr>", desc = "Fzf Lines" },
                { "<localleader>fc", "<cmd>FzfLua git_hunks<cr>", desc = "Fzf Git Hunks" },
                { "<localleader>fC", "<cmd>FzfLua changes<cr>", desc = "Fzf Changes" },
                { "<localleader>ft", "<cmd>FzfLua tabs<cr>", desc = "Fzf Tabs" },
                { "<localleader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Fzf Oldfiles" },
                { "<localleader>fq", "<cmd>FzfLua resume<cr>", desc = "Fzf Resume" },
                { "<localleader>fQ", "<cmd>FzfLua global<cr>", desc = "Fzf Global" },
                { "<localleader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Fzf Live Grep" },
                { "<localleader>fG", "<cmd>FzfLua grep<cr>", desc = "Fzf Grep" },
                { "<localleader>fb", "<cmd>FzfLua buffers<cr>", desc = "Fzf Buffers" },
                { "<localleader>fi", "<cmd>FzfLua lsp_finder<cr>", desc = "Fzf LSP Find" },
                { "<localleader>fo", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Fzf LSP Live Workspace Symbols" },
                { "<localleader>fO", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Fzf LSP Document Symbols" },
                { "<localleader>df", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics (fzf)" },
                { "<localleader>dF", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "Workspace LSP Diagnostics (fzf)" },
                { "<localleader>dv", "<cmd>FzfLua diagnostics_document<cr>", desc = "Workspace Diagnostics (fzf)" },
                { "<localleader>gb", "<cmd>FzfLua git_blame<cr>", desc = "Git Blame" },
                { "<localleader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits" },
                { "<localleader>gC", "<cmd>FzfLua git_bcommits<cr>", desc = "Git Commits (buffer)" },
                { "<localleader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
                { "<localleader>gw", "<cmd>FzfLua git_worktrees<cr>", desc = "Git Worktrees" },
                { "<localleader>gn", "<cmd>FzfLua git_branches<cr>", desc = "Git Branches" },
                { "<localleader>gr", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
                { "<localleader>gt", "<cmd>FzfLua git_tags<cr>", desc = "Git Tags" },
            }
        end)(),
    },
}
