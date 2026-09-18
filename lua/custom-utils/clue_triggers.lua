local M = {}

local pending = {}

-- helps to ensure the clue triggers are defined last. however this seems to not be perfect so i have to od this and also define clue at the bottom of editor.lua
function M.ensure(bufnr)
    bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
    if pending[bufnr] then
        vim.notify("clue_triggers: ensure already pending for buf " .. bufnr, vim.log.levels.WARN)
        return
    end
    pending[bufnr] = true

    vim.schedule(function()
        pending[bufnr] = nil
        if not vim.api.nvim_buf_is_valid(bufnr) then
            vim.notify("clue_triggers: buf " .. bufnr .. " is not valid", vim.log.levels.WARN)
            return
        end
        local ok, miniclue_or_err = pcall(require, "mini.clue")
        if not ok then
            vim.notify("clue_triggers: failed to require mini.clue: " .. tostring(miniclue_or_err), vim.log.levels.ERROR)
            return
        end

        local ensure_ok, ensure_err = pcall(miniclue_or_err.ensure_buf_triggers, bufnr)
        if not ensure_ok then
            vim.notify("clue_triggers: ensure_buf_triggers failed: " .. tostring(ensure_err), vim.log.levels.ERROR)
        end
    end)
end

return M
