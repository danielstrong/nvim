-- Tracks the last-used neotree configuration so <localleader>e can restore it.
-- source: "filesystem" | "git_status" | "buffers"
-- dir: string | nil (only used for filesystem source)
-- preview: bool
local neotree_last = {
    source = nil, -- nil means never opened
    dir = nil,
    preview = false,
}

local function neotree_open(source, dir)
    local cmd = require("neo-tree.command")
    cmd.execute({ source = source, action = "focus", dir = dir })
    neotree_last.source = source
    neotree_last.dir = dir
    neotree_last.preview = false
end

local function neotree_is_open()
    local renderer = require("neo-tree.ui.renderer")
    local manager = require("neo-tree.sources.manager")
    for _, source in ipairs({ "filesystem", "git_status", "buffers" }) do
        local ok, state = pcall(manager.get_state, source)
        if ok and state and renderer.window_exists(state) then
            return true, state
        end
    end
    return false, nil
end

local function neotree_is_focused()
    local renderer = require("neo-tree.ui.renderer")
    local manager = require("neo-tree.sources.manager")
    local cur_win = vim.api.nvim_get_current_win()
    for _, source in ipairs({ "filesystem", "git_status", "buffers" }) do
        local ok, state = pcall(manager.get_state, source)
        if ok and state and renderer.window_exists(state) and state.winid == cur_win then
            return true, state
        end
    end
    return false, nil
end

-- Switch to a specific source+dir if tree is open, otherwise toggle it.
-- Closes only if already focused on this exact source+dir.
local function neotree_switch(source, dir)
    local cmd = require("neo-tree.command")
    local is_open, _ = neotree_is_open()
    local is_focused, focused_state = neotree_is_focused()

    if is_open then
        -- Already on this exact source+dir and focused → close
        if is_focused and focused_state and focused_state.name == source and (dir == nil or focused_state.path == dir) then
            cmd.execute({ action = "close" })
            return
        end
        -- Otherwise switch to the requested source/dir
        cmd.execute({ source = source, action = "focus", dir = dir })
    else
        cmd.execute({ source = source, action = "focus", dir = dir })
    end
    neotree_last.source = source
    neotree_last.dir = dir
    neotree_last.preview = false
end

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = true,
        keys = {

            {
                "<leader>fE",
                function()
                    neotree_switch("filesystem", LazyVim.root())
                end,
                desc = "Explorer NeoTree (Root Dir)",
            },
            {
                "<leader>fe",
                function()
                    neotree_switch("filesystem", vim.uv.cwd())
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            {
                "<leader>ge",
                function()
                    neotree_switch("git_status", nil)
                end,
                desc = "Git Explorer",
            },
            {
                "<leader>be",
                function()
                    neotree_switch("buffers", nil)
                end,
                desc = "Buffer Explorer",
            },
            {
                "<leader>e",
                function()
                    local is_focused, _ = neotree_is_focused()
                    local is_open, _ = neotree_is_open()

                    if is_focused then
                        -- Close the tree
                        require("neo-tree.command").execute({ action = "close" })
                    elseif is_open then
                        -- Refocus the tree, preserving source/dir/preview
                        local source = neotree_last.source or "filesystem"
                        local dir = neotree_last.dir
                        require("neo-tree.command").execute({ source = source, action = "focus", dir = dir })
                    else
                        -- Open to last used, or default to filesystem cwd
                        local source = neotree_last.source or "filesystem"
                        local dir = neotree_last.dir or vim.uv.cwd()
                        neotree_open(source, dir)
                    end
                end,
                desc = "Toggle NeoTree (smart)",
            },
        },
        opts = {
            window = {
                mappings = {
                    ["<cr>"] = function(state)
                        local node = state.tree:get_node()
                        if node.type == "file" then
                            local in_preview = require("neo-tree.sources.common.preview").is_active()
                            neotree_last.preview = in_preview
                            require("neo-tree.sources.filesystem.commands").open(state)
                            if not in_preview then
                                require("neo-tree.command").execute({ action = "close" })
                            end
                        else
                            require("neo-tree.sources.filesystem.commands").open(state)
                        end
                    end,
                    ["O"] = "open",
                    ["Y"] = function(state)
                        local path = state.tree:get_node().path
                        local name = vim.fn.fnamemodify(path, ":t")
                        vim.fn.setreg("+", name)
                        vim.notify("Copied: " .. name)
                    end,
                    ["<localleader>c"] = function(state)
                        local path = state.tree:get_node().path
                        local rel = vim.fn.fnamemodify(path, ":.")
                        vim.fn.setreg("+", rel)
                        vim.notify("Copied: " .. rel)
                    end,
                    ["<localleader>C"] = function(state)
                        local path = state.tree:get_node().path
                        vim.fn.setreg("+", path)
                        vim.notify("Copied: " .. path)
                    end,
                    ["W"] = {
                        function(state)
                            require("lazy.util").open(state.tree:get_node().path, { system = true })
                        end,
                        desc = "Open with System Application",
                    },
                },
            },
        },
    },
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
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
                view = {
                    width = 48,
                },
                filters = {
                    -- https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt#L2172
                    dotfiles = false,
                    -- git_ignored = true,
                    git_ignored = true,
                    -- custom = { "^node_modules$" },
                    custom = { "^node_modules$" },
                },
            })
        end,
    },
}
