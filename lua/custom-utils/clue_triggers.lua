-- mini.clue triggers are buffer-local mappings that only honor <nowait> while they are the
-- newest ones for that key. Plugins that map buffer-locally after mini.clue's BufWinEnter /
-- LspAttach pass (gitsigns, nvim-tree) must call ensure() so the triggers are recreated last.
local M = {}

local pending = {}

function M.ensure(bufnr)
    bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
    if pending[bufnr] then
        return
    end
    pending[bufnr] = true

    vim.schedule(function()
        pending[bufnr] = nil
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end
        local ok, miniclue = pcall(require, "mini.clue")
        if ok then
            miniclue.ensure_buf_triggers(bufnr)
        end
    end)
end

return M
