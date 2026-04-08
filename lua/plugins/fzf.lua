return {
    {
        "ibhagwan/fzf-lua",
        opts = {
            fzf_bin = "sk",
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
                header = false,
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
            keymap = {
                builtin = {
                    ["<M-Esc>"] = "hide",
                    ["<F1>"] = "toggle-help",
                    ["<ctrl-z>"] = "toggle-fullscreen",
                    ["ctrl-P"] = "toggle-preview-wrap",
                    ["ctrl-p"] = "toggle-preview",
                    ["<F5>"] = "toggle-preview-cw",
                    ["<F6>"] = "toggle-preview-behavior",
                    ["<F7>"] = "toggle-preview-ts-ctx",
                    ["<F8>"] = "preview-ts-ctx-dec",
                    ["<F9>"] = "preview-ts-ctx-inc",
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
                    ["alt-a"] = "toggle-all",
                    ["alt-g"] = "first",
                    ["alt-G"] = "last",
                    ["ctrl-P"] = "toggle-preview-wrap",
                    ["ctrl-p"] = "toggle-preview",
                    ["shift-down"] = "preview-page-down",
                    ["shift-up"] = "preview-page-up",
                },
            },
        },
        keys = (function()
            local function fzf_files()
                require("fzf-lua").files({ cmd = "fd --type f --no-ignore --exclude node_modules --exclude .git" })
            end
            local function fzf_files_path()
                require("fzf-lua").files({ formatter = false })
            end
            local function fzf_git_changes()
                require("fzf-lua").fzf_exec("git diff --name-only && git ls-files --deleted --others --killed --exclude-standard", { actions = require("fzf-lua").defaults.actions.files, previewer = "builtin" })
            end
            local function fzf_text_search_live_grep()
                require("fzf-lua").live_grep({ rg_opts = "--fixed-strings --color=always --no-heading --with-filename --line-number --column", prompt = "Text> " })
            end
            local function fzf_text_search_grep()
                require("fzf-lua").grep({ rg_opts = "--fixed-strings --color=always --no-heading --with-filename --line-number --column", prompt = "Text> " })
            end
            return {
                { "'fE", fzf_files, desc = "Fzf Files" },
                { "'fe", "<cmd>FzfLua files<cr>", desc = "Fzf All files" },
                { "'fp", fzf_files_path, desc = "Fzf files (path search)" },
                { "'fD", "<cmd>FzfLua git_diff<cr>", desc = "Fzf Git Diff" },
                { "'fd", fzf_git_changes, desc = "Fzf Git Changes" },
                { "'fs", fzf_text_search_live_grep, desc = "Fzf Live Text Search" },
                { "'fS", fzf_text_search_grep, desc = "Fzf Text Search" },
                { "'fc", "<cmd>FzfLua git_hunks<cr>", desc = "Fzf Git Hunks" },
                { "'fC", "<cmd>FzfLua changes<cr>", desc = "Fzf Changes" },
                { "'fr", "<cmd>FzfLua oldfiles<cr>", desc = "Fzf Oldfiles" },
                { "'fg", "<cmd>FzfLua live_grep<cr>", desc = "Fzf Live Grep" },
                { "'fG", "<cmd>FzfLua grep<cr>", desc = "Fzf Grep" },
                { "<localleader>fb", "<cmd>FzfLua buffers<cr>", desc = "Fzf Buffers" },
                { "<localleader>fj", "<cmd>FzfLua jumps<cr>", desc = "Fzf Jumps" },
                { "<localleader>fo", "<cmd>FzfLua commands<cr>", desc = "Fzf Commands" },
                { "<localleader>fp", "<cmd>FzfLua builtin<cr>", desc = "Fzf Builtin" },
                { "<localleader>f?", "<cmd>FzfLua keymaps<cr>", desc = "Fzf Keymaps" },
            }
        end)(),
    },
}
