return {
    { "ellisonleao/gruvbox.nvim", lazy = true },
    { "Shatur/neovim-ayu", name = "ayu", lazy = true },
    { "kepano/flexoki-neovim", name = "flexoki", lazy = true },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = { style = "night" },
    },
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
        specs = {
            {
                "akinsho/bufferline.nvim",
                optional = true,
                opts = function(_, opts)
                    if (vim.g.colors_name or ""):find("catppuccin") then
                        opts.highlights = require("catppuccin.special.bufferline").get_theme()
                    end
                end,
            },
        },
    },
    { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = true, priority = 1000 },
    { "EdenEast/nightfox.nvim", name = "nightfox", lazy = true },
    { "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true },
    {
        "maxmx03/solarized.nvim",
        lazy = true,
        priority = 1000,
        ---@type solarized.config
        opts = {},
    },
    {
        "svrana/neosolarized.nvim",
        lazy = true,
        priority = 1000,
        config = function()
            require("neosolarized").setup({
                comment_italics = true,
                background_set = false,
            })
            vim.notify("called config on neosolarized")
            -- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#053040" })
        end,
        dependencies = {
            "tjdevries/colorbuddy.nvim",
        },
    },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = true, priority = 1000 },
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
    },
}
