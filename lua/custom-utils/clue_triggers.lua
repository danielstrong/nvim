local M = {}

local pending = {}

-- helps to ensure the clue triggers are defined last. however this seems to not be perfect so i have to od this and also define clue at the bottom of editor.lua
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
