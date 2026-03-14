return {
    -- this fixes "vim" not being detected in lua config files
    -- { "folke/neodev.nvim", opts = {} },
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
