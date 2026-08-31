local M = {}

local function real_win_entries(make)
    local extras = require("which-key.extras")
    local ret = {}
    for i = 1, vim.fn.winnr("$") do
        local win = vim.fn.win_getid(i)
        if vim.api.nvim_win_get_config(win).relative == "" then
            local name = extras.bufname(vim.api.nvim_win_get_buf(win))
            ret[#ret + 1] = make(i, name)
        end
    end
    return ret
end

function M.wk_window_jump_expand()
    return real_win_entries(function(i, name)
        return {
            tostring(i),
            function()
                vim.cmd(i .. "wincmd w")
            end,
            desc = name,
            icon = { cat = "file", name = name },
        }
    end)
end

function M.wk_window_move_expand()
    return real_win_entries(function(i, name)
        return {
            tostring(i),
            function()
                require("window-move").window_swap_to(i)
            end,
            desc = "Move to " .. name,
            icon = { cat = "file", name = name },
            mode = { "n", "x" },
        }
    end)
end

return M
