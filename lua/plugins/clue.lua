return {
    {
        "nvim-mini/mini.clue",
        version = false,
        enabled = true,
        config = function(_, opts)
            local miniclue = require("mini.clue")
            miniclue.setup({

                -- Array of opt-in triggers which start custom key query process.
                -- **Needs to have something in order to show clues**.
                triggers = {
                    { mode = { "n", "x" }, keys = "<Leader>" },
                    { mode = { "n", "x" }, keys = "<LocalLeader>" },
                    { mode = "n", keys = "[" },
                    { mode = "n", keys = "]" },
                    { mode = "i", keys = "<C-x>" },
                    { mode = { "n", "x" }, keys = "g" },
                    { mode = { "n", "x" }, keys = "Z" },
                    { mode = { "n", "x" }, keys = "c" },
                    { mode = { "n", "x" }, keys = "h" },
                    { mode = { "n", "x" }, keys = "'" },
                    { mode = { "n", "x" }, keys = "`" },
                    { mode = { "n", "x" }, keys = '"' },
                    { mode = { "i", "c" }, keys = "<C-r>" },
                    { mode = "n", keys = "<C-w>" },
                    { mode = "n", keys = "<C-q>" },
                    { mode = { "n", "x" }, keys = "z" },
                },

                -- Array of extra clues to show
                clues = {
                    -- { mode = "n", keys = "]b", postkeys = "]" },
                    -- { mode = "n", keys = "]w", postkeys = "]" },

                    -- { mode = "n", keys = "[b", postkeys = "[" },
                    -- { mode = "n", keys = "[w", postkeys = "[" },
                    { mode = "n", keys = "<localleader>b", desc = "+Buffers" },
                    { keys = "<localleader>a", desc = "+Actions", mode = { "n", "x" } },
                    { keys = "<localleader>o", desc = "+Diffview", mode = { "n", "x" } },
                    { keys = "<localleader>K", desc = "+LSP Buffer", mode = { "n", "x" } },
                    { keys = "<localleader>N", desc = "+Nvim Raw", mode = { "n", "x" } },
                    { keys = "<localleader>Q", desc = "+Quick", mode = { "n", "x" } },
                    { keys = "<localleader>W", desc = "+Save", mode = { "n", "x" } },
                    { keys = "<localleader>d", desc = "+Diff Tools", mode = { "n", "x" } },
                    { keys = "<localleader>f", desc = "+Fuzzy", mode = { "n", "x" } },
                    { keys = "<localleader>g", desc = "+Git", mode = { "n", "x" } },
                    { keys = "<localleader>h", desc = "+Hunk", mode = { "n", "x" } },
                    { keys = "<localleader>j", desc = "+Copy Store", mode = { "n", "x" } },
                    { keys = "<localleader>k", desc = "+Language Tools", mode = { "n", "x" } },
                    { keys = "<localleader>n", desc = "+Nvim", mode = { "n", "x" } },
                    { keys = "<localleader><localleader>", desc = "+Ctrl", mode = { "n", "x" } },
                    { keys = "<C-q>", desc = "+Tabs", mode = { "n", "x" } },
                    { keys = "<C-q>m", desc = "+Move Tab", mode = { "n", "x" } },
                    { keys = "<localleader>t", desc = "+Tabs", mode = { "n", "x" } },
                    { keys = "<localleader>tm", desc = "+Move Tab", mode = { "n", "x" } },
                    { keys = "<localleader>r", desc = "+Replace", mode = { "n", "x" } },
                    { keys = "<localleader>u", desc = "+UI", mode = { "n", "x" } },
                    { keys = "<localleader>z", desc = "+Session", mode = { "n", "x" } },
                    { keys = "Z", desc = "+File", mode = { "n", "x" } },
                    { keys = "gm", desc = "+Modify Code", mode = { "n", "x" } },
                    { keys = "<localleader>=", desc = "+Fix Indention", mode = { "n", "x" } },
                    { keys = "<localleader>=z", desc = "+Formatters", mode = { "n", "x" } },
                    miniclue.gen_clues.square_brackets(),
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                },
                --
                -- Clue window settings
                window = {
                    -- Floating window config
                    config = function(buf_id)
                        local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
                        local content_width = 0
                        for _, line in ipairs(lines) do
                            content_width = math.max(content_width, vim.fn.strdisplaywidth(line))
                        end

                        local has_statusline = vim.o.laststatus > 0
                        local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
                        local avail_height = vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0) - (has_statusline and 1 or 0) - 2

                        return {
                            width = math.max(30, math.min(content_width + 1, 60)),
                            height = math.max(1, math.min(math.max(#lines, 4), math.floor(0.75 * vim.o.lines), avail_height)),
                            border = "rounded",
                            title_pos = "left",
                        }
                    end,

                    -- Delay before showing clue window
                    delay = 200,

                    -- Keys to scroll inside the clue window
                    scroll_down = "<C-d>",
                    scroll_up = "<C-u>",
                },
            })

            local function clue_highlights()
                local links = {
                    MiniClueBorder = "FloatBorder",
                    MiniClueTitle = "FloatTitle",
                    MiniClueDescGroup = "Keyword",
                    MiniClueDescSingle = "Identifier",
                    MiniClueNextKey = "Function",
                    MiniClueNextKeyWithPostkeys = "Function",
                    MiniClueSeparator = "Comment",
                }
                for group, target in pairs(links) do
                    vim.api.nvim_set_hl(0, group, { link = target })
                end
            end

            clue_highlights()
            vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = clue_highlights })
        end,
    },
}
