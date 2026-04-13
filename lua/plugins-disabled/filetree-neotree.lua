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
}
