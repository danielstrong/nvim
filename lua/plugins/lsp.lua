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
            inlay_hints = {
                enabled = false,
            },
            servers = {
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
}
