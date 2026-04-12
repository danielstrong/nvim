return {
    -- this fixes "vim" not being detected in lua config files
    -- { "folke/neodev.nvim", opts = {} },
    -- {
    -- "folke/lazydev.nvim",
    -- enabled = false,
    -- },
    {
        "neovim/nvim-lspconfig",
        opts = {

            -- options for vim.diagnostic.config()
            ---@type vim.diagnostic.Opts
            diagnostics = {
                underline = true,
                update_in_insert = false,
                -- virtual_text = {
                --     spacing = 4,
                --     source = "if_many",
                --     prefix = "●",
                --     -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                --     -- prefix = "icons",
                -- },
                -- virtual_text = false,
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
                        [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
                        [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
                        [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
                    },
                },
            },

            inlay_hints = {
                enabled = false,
            },
            servers = {
                ["*"] = {
                    keys = {
                        { "cq", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
                        { "cz", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
                        { "cZ", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
                        {
                            "cR",
                            function()
                                Snacks.rename.rename_file()
                            end,
                            desc = "Rename File",
                            mode = { "n" },
                            has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
                        },
                        { "cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
                        { "cQ", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
                    },
                },
            },
        },
    },
}
