local M = {}

local function buf_label(bufnr)
    local fname = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
    return fname ~= "" and fname or "[No Name]"
end

-- Display name of a tab: its `tab_name` var when set, otherwise the file name(s)
-- it shows. With opts.splits every real window is listed, not just the current one.
function M.tab_name(tabnr, opts)
    local tabpage = vim.api.nvim_list_tabpages()[tabnr]
    if not tabpage then
        return nil
    end
    local ok, name = pcall(vim.api.nvim_tabpage_get_var, tabpage, "tab_name")
    if ok and name and name ~= "" then
        return name
    end
    if not (opts and opts.splits) then
        return buf_label(vim.fn.tabpagebuflist(tabnr)[vim.fn.tabpagewinnr(tabnr)])
    end
    local names = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            local bufnr = vim.api.nvim_win_get_buf(win)
            if vim.bo[bufnr].filetype ~= "NvimTree" then
                table.insert(names, buf_label(bufnr))
            end
        end
    end
    return #names > 0 and table.concat(names, " | ") or "[No Name]"
end

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

-- which-key descriptions for the tab number keys. These only annotate the real
-- keymaps (no rhs), so the descs stay dynamic while the keymaps keep working.
function M.wk_tab_specs()
    local ret = {}
    for _, prefix in ipairs({ "<localleader>t", "<C-q>" }) do
        for i = 1, 9 do
            local icon = function()
                return { cat = "file", name = M.tab_name(i) or "" }
            end
            ret[#ret + 1] = {
                prefix .. i,
                desc = function()
                    return M.tab_name(i, { splits = true }) or ("Navigate to tab " .. i)
                end,
                icon = icon,
                mode = { "n", "x" },
            }
            ret[#ret + 1] = {
                prefix .. "m" .. i,
                desc = function()
                    local name = M.tab_name(i, { splits = true })
                    return name and ("Move to " .. name) or ("Move tab to " .. i)
                end,
                icon = icon,
                mode = { "n", "x" },
            }
        end
    end
    return ret
end

return M
