return {
    {
        "nvim-tree/nvim-tree.lua",
        enabled = true,
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            -- Keymap to toggle the NvimTree
            {
                "<localleader>E",
                function()
                    local view = require("nvim-tree.view")
                    if view.is_visible() and view.get_winnr() == vim.api.nvim_get_current_win() then
                        require("nvim-tree.api").tree.close()
                    else
                        require("nvim-tree.api").tree.focus()
                    end
                end,
                desc = "Focus NvimTree",
            },
            -- Keymap to open NvimTree to the current file's location
            {
                "<localleader>e",
                function()
                    local view = require("nvim-tree.view")
                    if view.is_visible() and view.get_winnr() == vim.api.nvim_get_current_win() then
                        require("nvim-tree.api").tree.close()
                    else
                        require("nvim-tree.api").tree.find_file({ open = true, focus = true })
                    end
                end,
                desc = "Focus NvimTree on current",
            },
        },
        -- actions = {
        -- open_file = {
        -- quit_on_open = true, -- Close the tree after opening a file in the current window
        -- replacing_current_buffer = true, -- Open the file in the current window/buffer
        -- You can also add other options like 'resize_window'
        -- },
        -- },
        config = function()
            local function on_attach(bufnr)
                local api = require("nvim-tree.api")

                -- Preserve all default nvim-tree keymaps
                -- api.config.mappings.default_on_attach(bufnr)
                api.map.on_attach.default(bufnr)

                vim.keymap.set("n", "<CR>", function()
                    local node = api.tree.get_node_under_cursor()
                    if not node then
                        return
                    end
                    if node.type == "directory" then
                        api.node.open.edit()
                    else
                        api.node.open.edit()
                        api.tree.close()
                    end
                end, { buffer = bufnr, noremap = true, silent = true, desc = "Open file and close tree" })

                vim.keymap.set("n", "i", api.node.open.preview, { buffer = bufnr, noremap = true, silent = true, desc = "Preview file (keep tree focused)" })

                vim.keymap.set("n", "O", function()
                    local marks = api.marks.list()
                    local files = {}
                    for _, node in ipairs(marks) do
                        if node.type == "file" then
                            table.insert(files, node.absolute_path)
                        end
                    end
                    if #files ~= 2 then
                        vim.notify("Mark exactly 2 files with 'm' to diff", vim.log.levels.WARN)
                        return
                    end
                    api.tree.close()
                    vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
                    vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(files[2]))
                end, { buffer = bufnr, noremap = true, silent = true, desc = "Diff marked files" })

                vim.keymap.set("n", "<localleader>c", function()
                    local node = api.tree.get_node_under_cursor()
                    if node and node.absolute_path then
                        local rel = vim.fn.fnamemodify(node.absolute_path, ":.")
                        vim.fn.setreg("+", rel)
                        vim.notify("Copied: " .. rel)
                    end
                end, { buffer = bufnr, noremap = true, silent = true, desc = "NvimTree copy relative path" })

                vim.keymap.set("n", "<localleader>C", function()
                    local node = api.tree.get_node_under_cursor()
                    if node and node.absolute_path then
                        vim.fn.setreg("+", node.absolute_path)
                        vim.notify("Copied: " .. node.absolute_path)
                    end
                end, { buffer = bufnr, noremap = true, silent = true, desc = "NvimTree copy absolute path" })

                vim.keymap.set("n", "gf", api.tree.search_node, { buffer = bufnr, noremap = true, silent = true, desc = "Search" })
                vim.keymap.set("n", "<C-s>", api.node.run.system, { buffer = bufnr, noremap = true, silent = true, desc = "Run System" })
                vim.keymap.set("n", "s", api.node.open.horizontal, { buffer = bufnr, noremap = true, silent = true, desc = "Open: Horizontal Split" })
                vim.keymap.set("n", "S", api.node.open.vertical, { buffer = bufnr, noremap = true, silent = true, desc = "Open: Vertical Split" })

                -- vim.keymap.set("n", "C", function()
                --     api.filter.git.clean.toggle()
                --     api.tree.expand_all()
                -- end, { buffer = bufnr, noremap = true, silent = true, desc = "Toggle git clean filter + expand all" })
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
                view = {
                    float = {
                        enable = false,
                    },
                    width = 48,
                },
                filters = {
                    -- https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt#L2172
                    dotfiles = false,
                    git_ignored = true,
                    custom = { "^node_modules$" },
                },
            })
        end,
    },
}
