-- Diffview-specific tab labelling, kept out of `tabs_windows_buffers` so it can
-- be dropped without touching the generic logic. Every entry point returns nil
-- when Diffview isn't installed, isn't loaded, or the tab isn't one of its views.
local M = {}

-- Diffview view class -> the command that produced it, so a Diffview tab is
-- labelled by what it actually shows rather than a generic "Diffview".
local view_labels = {
    DiffView = "DiffviewOpen",
    NullDiffView = "Diffview",
    FileHistoryView = "DiffviewFileHistory",
    FileDiffView = "DiffviewDiffFiles",
    FileMergeView = "DiffviewMergeFiles",
    FileDirDiffView = "DiffviewDirDiff",
}

-- `package.loaded` rather than `require`: never pulls Diffview in, and is a
-- plain nil check when the plugin is absent or still lazy-loaded.
local function tabpage_to_view(tabpage)
    local lib = package.loaded["diffview.lib"]
    if not (lib and lib.tabpage_to_view) then
        return nil
    end
    local ok, view = pcall(lib.tabpage_to_view, tabpage)
    return ok and view or nil
end

local function cur_entry(view)
    local entry
    if type(view.cur_file) == "function" then
        local ok, result = pcall(view.cur_file, view)
        entry = ok and result or nil
    end
    return entry or view.cur_entry or (view.panel and view.panel.cur_file)
end

-- Label for a Diffview tab whose panel is hidden. With the panel open the window
-- list already describes the tab, so nil is returned and the caller's normal
-- file-name labelling applies.
---@param tabpage integer
---@return string?
function M.tab_name(tabpage)
    local view = tabpage_to_view(tabpage)
    if not (view and view.panel and view.panel.is_open) then
        return nil
    end
    local ok, panel_open = pcall(view.panel.is_open, view.panel)
    if not ok or panel_open then
        return nil
    end

    local label = view_labels[view.class and view.class.__name] or "Diffview"
    local entry = cur_entry(view)
    local file = entry and entry.path and vim.fn.fnamemodify(entry.path, ":t")
    return file and file ~= "" and (label .. " - " .. file) or label
end

return M
