return {
    -- make conform treat apexcode files as being able to autoformat with prettiet
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                apexcode = { "prettier" },
            },
            formatters = {
                prettier = {
                    condition = function(self, ctx)
                        local ft = vim.bo[ctx.buf].filetype
                        if ft == "apexcode" then
                            return true
                        end
                        -- fall back to LazyVim's default condition
                        local prettier_extra = require("lazyvim.plugins.extras.formatting.prettier")
                        return prettier_extra.has_parser(ctx)
                    end,
                },
            },
        },
    },
    -- specify how to find the apex language server
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                apex_ls = {
                    apex_jar_path = vim.fn.stdpath("data") .. "/mason/packages/apex-language-server/extension/dist/apex-jorje-lsp.jar",
                    apex_enable_semantic_errors = false,
                    apex_enable_completion_statistics = false,
                    cmd = {
                        "/opt/homebrew/opt/openjdk@21/bin/java",
                        "-cp",
                        vim.fn.stdpath("data") .. "/mason/packages/apex-language-server/extension/dist/apex-jorje-lsp.jar",
                        "-Ddebug.internal.errors=true",
                        "-Ddebug.semantic.errors=false",
                        "-Ddebug.completion.statistics=false",
                        "-Dlwc.typegeneration.disabled=true",
                        "apex.jorje.lsp.ApexLanguageServerLauncher",
                    },
                },
            },
        },
    },
}
