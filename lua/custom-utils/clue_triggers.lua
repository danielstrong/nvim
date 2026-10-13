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

-- Snacks.keymap applies LSP keymaps (gd, gr, ...) on a 100ms debounce, so wait longer than that
local LSP_KEYMAP_DELAY_MS = 200
local lsp_timers = {}

local function ensure_after_lsp_keymaps(bufnr)
    local timer = lsp_timers[bufnr]
    if timer == nil then
        timer = assert(vim.uv.new_timer())
        lsp_timers[bufnr] = timer
    end
    timer:stop()
    timer:start(LSP_KEYMAP_DELAY_MS, 0, function()
        timer:close()
        lsp_timers[bufnr] = nil
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
                M.ensure(bufnr)
            end
        end)
    end)
end

function M.setup_lsp_ensure()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("clue_triggers_lsp", { clear = true }),
        callback = function(ev)
            ensure_after_lsp_keymaps(ev.buf)
        end,
    })

    -- Snacks re-applies LSP keymaps when a server dynamically registers capabilities
    local register_capability = vim.lsp.handlers["client/registerCapability"]
    vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
            for bufnr in pairs(client.attached_buffers) do
                ensure_after_lsp_keymaps(bufnr)
            end
        end
        return ret
    end
end

return M
