local M = {}

local function buf_label(bufnr)
    local fname = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
    return fname ~= "" and fname or "[No Name]"
end

local function default_tab_name(tabnr, tabpage, opts)
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
--
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
    -- Delete the next line to drop Diffview-aware tab names.
    return require("custom-utils.diffview_windows_buffers").tab_name(tabpage) or default_tab_name(tabnr, tabpage, opts)
end

return M
