return {
    { "ellisonleao/gruvbox.nvim", lazy = true },
    { "Shatur/neovim-ayu", name = "ayu", lazy = true },
    { "kepano/flexoki-neovim", name = "flexoki", lazy = true },
    { "folke/tokyonight.nvim", lazy = true, opts = { style = "night" } },
    {
        "catppuccin/nvim",
        lazy = true,
        name = "catppuccin",
        opts = {
            lsp_styles = {
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            integrations = {
                aerial = true,
                alpha = true,
                cmp = true,
                dashboard = true,
                flash = true,
                fzf = true,
                grug_far = true,
                gitsigns = true,
                headlines = true,
                illuminate = true,
                indent_blankline = { enabled = true },
                leap = true,
                lsp_trouble = true,
                mason = true,
                mini = true,
                navic = { enabled = true, custom_bg = "lualine" },
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                snacks = true,
                telescope = true,
                treesitter_context = true,
                which_key = true,
            },
        },
        -- specs = {
        --     {
        --         "akinsho/bufferline.nvim",
        --         optional = true,
        --         opts = function(_, opts)
        --             if (vim.g.colors_name or ""):find("catppuccin") then
        --                 opts.highlights = require("catppuccin.special.bufferline").get_theme()
        --             end
        --         end,
        --     },
        -- },
    },
    { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = true, priority = 1000 },
    { "EdenEast/nightfox.nvim", name = "nightfox", lazy = true },
    { "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true, opts = { transparent = false } },
    { "maxmx03/solarized.nvim", lazy = true, priority = 1000, opts = {} },
    { "svrana/neosolarized.nvim", lazy = true, priority = 1000, opts = { comment_italics = true, background_set = false }, dependencies = { "tjdevries/colorbuddy.nvim" } },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = true, priority = 1000 },
    { "saran13raj/wheat-fox.nvim", priority = 1000, lazy = true, name = "wheat-fox" },
    { "miikanissi/modus-themes.nvim", priority = 1000, lazy = true, name = "modus" },
    {
        "LazyVim/LazyVim",
        opts = {
            -- colorscheme = "hybrid",
            -- colorscheme = "gruvbox",
            -- colorscheme = "catppuccin",
            -- colorscheme = "tokyonight-night",
            -- colorscheme = "tomorrow-night",
            -- colorscheme = "nightfox",
            colorscheme = "kanagawa",
            -- colorscheme = "kanagawa-dragon",
            -- colorscheme = "wheat-fox",
            -- colorscheme = "flexoki",
            -- colorscheme = "kanagawa-dragon",
            -- colorscheme = "nightfly",
            -- colorscheme = "rose-pine",
            -- colorscheme = "solarized",
            -- colorscheme = "neosolarized",
            -- colorscheme = "carbonfox",
            -- colorscheme = "nightfly",
            -- colorscheme = "ayu",
            -- colorscheme = "ayu-dark",
        },
        init = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                -- group = augroup("colorscheme"),
                pattern = "*",
                callback = function()
                    -- vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cccccc", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#cccccc", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "StatusLineSection", { fg = "#cccccc", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "StatusLineSectionV", { fg = "#f4bf75", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "StatusLineSectionI", { fg = "#90a959", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "StatusLineSectionC", { fg = "#6a9fb5", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "StatusLineSectionR", { fg = "#aac474", bg = "#090909" })

                    -- vim.api.nvim_set_hl(0, "Normal", { bg = "#010101" })
                    -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "#010101" })
                    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#010101" })
                    -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "#010101" })
                    -- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#010101" })
                    -- vim.api.nvim_set_hl(0, "LineNr", { bg = "#010101" })
                    -- vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#010101" })
                    -- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#151515" })
                    -- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#777777" })
                    -- vim.api.nvim_set_hl(0, "StatusLine", { fg = "#aaaaaa", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#555555", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "TabLine", { fg = "#555555", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "TabLineFill", { fg = "#cccccc", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#aaaaaa", bg = "#090909" })
                    -- vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#6a9fb5" })
                    -- vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#cccccc", italic = true })
                    -- vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#909090", italic = true })

                    if vim.g.colors_name == "wheat-fox" then
                        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#151515" })
                        vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#090909" })
                    end

                    if vim.g.colors_name == "neosolarized" then
                        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#053040" })
                    end

                    if vim.g.colors_name ~= nil and vim.g.colors_name:find("kanagawa") then
                        vim.api.nvim_set_hl(0, "SpellBad", { fg = "#E82424" })
                        vim.api.nvim_set_hl(0, "SpellCap", { fg = "#FF9E3B" })
                        vim.api.nvim_set_hl(0, "SpellRare", { fg = "#7E9CD8" })
                        vim.api.nvim_set_hl(0, "SpellLocal", { fg = "#98BB6C" })
                    end
                end,
            })
        end,
    },
}
