return {
    { "ellisonleao/gruvbox.nvim", lazy = true },
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
    {
        "LazyVim/LazyVim",
        opts = {
            -- colorscheme = "hybrid",
            -- colorscheme = "gruvbox",
            -- colorscheme = "catppuccin",
            colorscheme = "tokyonight",
        },
    },
    {
        "LazyVim/LazyVim",
        init = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                    --
                    -- vim.cmd([[
                    --     hi StatusLine         ctermbg=darkgray ctermfg=black guibg=#cccccc guifg=#090909
                    --     hi StatusLineNC       ctermbg=black ctermfg=darkgray guibg=#cccccc guifg=#090909
                    --     hi StatusLineSection  ctermbg=darkgray ctermfg=black guibg=#cccccc guifg=#090909
                    --     hi StatusLineSectionV ctermbg=darkyellow ctermfg=black guibg=#f4bf75 guifg=#090909
                    --     hi StatusLineSectionI ctermbg=darkgreen ctermfg=black guibg=#90a959 guifg=#090909
                    --     hi StatusLineSectionC ctermbg=darkblue ctermfg=black guibg=#6a9fb5 guifg=#090909
                    --     hi StatusLineSectionR ctermbg=green ctermfg=black guibg=#aac474 guifg=#090909
                    --     hi Conceal            cterm=underline ctermbg=black ctermfg=lightgray term=underline guibg=#090909 guifg=#cccccc
                    -- ]])
                    --
                    vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cccccc", bg = "#090909" })
                    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#cccccc", bg = "#090909" })
                    vim.api.nvim_set_hl(0, "StatusLineSection", { fg = "#cccccc", bg = "#090909" })
                    vim.api.nvim_set_hl(0, "StatusLineSectionV", { fg = "#f4bf75", bg = "#090909" })
                    vim.api.nvim_set_hl(0, "StatusLineSectionI", { fg = "#90a959", bg = "#090909" })
                    vim.api.nvim_set_hl(0, "StatusLineSectionC", { fg = "#6a9fb5", bg = "#090909" })
                    vim.api.nvim_set_hl(0, "StatusLineSectionR", { fg = "#aac474", bg = "#090909" })
                    vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#6a9fb5" })
                end,
            })
        end,
    },
}
