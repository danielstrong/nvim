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
                "<localleader>wd",
                function()
                    require("nvim-tree.api").tree.toggle()
                end,
                desc = "Focus NvimTree",
            },
            -- Keymap to open NvimTree to the current file's location
            {
                "<localleader>wD",
                function()
                    local view = require("nvim-tree.view")
                    if view.is_visible() and view.get_winnr() == vim.api.nvim_get_current_win() then
                        require("nvim-tree.api").tree.close()
                    else
                        --     require("nvim-tree.api").tree.focus()
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

                vim.keymap.set("n", "<localleader>r", function()
                    require("nvim-tree.api").tree.reload()
                end, { buffer = bufnr, noremap = true, silent = true, desc = "reload tree" })

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

                local function mouse_open()
                    local node = api.tree.get_node_under_cursor()
                    if not node then
                        return
                    end
                    if node.type == "directory" then
                        -- api.node.open.edit()
                    else
                        api.node.open.preview()
                    end
                end

                -- vim.keymap.set("n", "<LeftRelease>", mouse_open, { buffer = bufnr, noremap = true, silent = true, desc = "Open file (keep tree focused) / toggle dir" })
                vim.keymap.set("n", "<2-LeftMouse>", api.node.open.preview, { buffer = bufnr, noremap = true, silent = true, desc = "Double-click: toggle dir / open file" })
                -- vim.keymap.set("n", "<2-LeftRelease>", "<Nop>", { buffer = bufnr, noremap = true, silent = true })
                -- vim.keymap.set("v", "<2-LeftMouse>", "<Esc>", { buffer = bufnr, noremap = true, silent = true })

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

                local function copy_rel_path_to_clipboard()
                    local node = api.tree.get_node_under_cursor()
                    if node and node.absolute_path then
                        local rel = vim.fn.fnamemodify(node.absolute_path, ":.")
                        vim.fn.setreg("+", rel)
                        vim.notify("Copied: " .. rel)
                    end
                end

                local function copy_abs_path_to_clipboard()
                    local node = api.tree.get_node_under_cursor()
                    if node and node.absolute_path then
                        vim.fn.setreg("+", node.absolute_path)
                        vim.notify("Copied: " .. node.absolute_path)
                    end
                end

                vim.keymap.set("n", "<localleader>c", copy_rel_path_to_clipboard, { buffer = bufnr, noremap = true, silent = true, desc = "NvimTree copy relative path" })
                vim.keymap.set("n", "<localleader>C", copy_abs_path_to_clipboard, { buffer = bufnr, noremap = true, silent = true, desc = "NvimTree copy absolute path" })
                vim.keymap.set("n", "<localleader>y", copy_rel_path_to_clipboard, { buffer = bufnr, noremap = true, silent = true, desc = "NvimTree copy relative path" })
                vim.keymap.set("n", "<localleader>Y", copy_abs_path_to_clipboard, { buffer = bufnr, noremap = true, silent = true, desc = "NvimTree copy absolute path" })

                vim.keymap.set("n", "gf", api.tree.search_node, { buffer = bufnr, noremap = true, silent = true, desc = "Search" })
                vim.keymap.set("n", "<C-s>", api.node.run.system, { buffer = bufnr, noremap = true, silent = true, desc = "Run System" })
                vim.keymap.set("n", "s", api.node.open.horizontal, { buffer = bufnr, noremap = true, silent = true, desc = "Open: Horizontal Split" })
                vim.keymap.set("n", "S", api.node.open.vertical, { buffer = bufnr, noremap = true, silent = true, desc = "Open: Vertical Split" })
                vim.keymap.set("n", "T", api.node.open.tab, { buffer = bufnr, noremap = true, silent = true, desc = "Open: New Tab" })

                -- vim.keymap.set("n", "C", function()
                --     api.filter.git.clean.toggle()
                --     api.tree.expand_all()
                -- end, { buffer = bufnr, noremap = true, silent = true, desc = "Toggle git clean filter + expand all" })

                vim.keymap.set("n", "<localleader>ds", function()
                    local node = api.tree.get_node_under_cursor()
                    if not node then
                        return
                    end

                    local paths = {}
                    if node.type == "directory" then
                        local function collect(n)
                            if n.type == "file" then
                                table.insert(paths, n.absolute_path)
                            elseif n.nodes then
                                for _, child in ipairs(n.nodes) do
                                    collect(child)
                                end
                            end
                        end
                        collect(node)
                    else
                        paths = { node.absolute_path }
                    end

                    -- Load any unloaded buffers so LSP can attach and publish diagnostics.
                    -- Track temp buffers so we can unload them after collecting.
                    local temp_bufs = {}
                    local buf_for_path = {}
                    for _, path in ipairs(paths) do
                        local pbufnr = vim.fn.bufnr(path)
                        local was_loaded = pbufnr ~= -1 and vim.fn.bufloaded(pbufnr) == 1
                        if not was_loaded then
                            pbufnr = vim.fn.bufadd(path)
                            vim.fn.bufload(pbufnr)
                            -- Attach LSP to the new buffer
                            vim.bo[pbufnr].buflisted = false
                            vim.api.nvim_buf_call(pbufnr, function()
                                vim.cmd("silent! doautocmd BufRead")
                            end)
                            table.insert(temp_bufs, pbufnr)
                        end
                        buf_for_path[path] = pbufnr
                    end

                    -- Give LSP time to publish diagnostics for newly loaded buffers
                    local delay = #temp_bufs > 0 and 800 or 0
                    vim.defer_fn(function()
                        local items = {}
                        for _, path in ipairs(paths) do
                            local pbufnr = buf_for_path[path]
                            if pbufnr and vim.api.nvim_buf_is_valid(pbufnr) then
                                for _, d in ipairs(vim.diagnostic.get(pbufnr)) do
                                    table.insert(items, {
                                        filename = path,
                                        lnum = d.lnum + 1,
                                        col = d.col + 1,
                                        text = d.message,
                                        type = d.severity == vim.diagnostic.severity.ERROR and "E" or d.severity == vim.diagnostic.severity.WARN and "W" or "I",
                                    })
                                end
                            end
                        end

                        -- Unload the temp buffers we created
                        for _, tbuf in ipairs(temp_bufs) do
                            if vim.api.nvim_buf_is_valid(tbuf) then
                                vim.api.nvim_buf_delete(tbuf, { force = true })
                            end
                        end

                        vim.fn.setqflist(items, "r")
                        local count = #items
                        if count == 0 then
                            vim.notify("No diagnostics found", vim.log.levels.INFO)
                        else
                            vim.notify(count .. " diagnostic(s) added to quickfix", vim.log.levels.INFO)
                        end
                    end, delay)
                end, { buffer = bufnr, noremap = true, silent = true, desc = "Diagnostics to Quickfix" })
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
                filesystem_watchers = {
                    enable = true,
                },
                view = {
                    float = {
                        enable = true,
                        -- width = 70,
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
