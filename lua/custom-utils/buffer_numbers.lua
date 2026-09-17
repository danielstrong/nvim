local M = {}

function M.bufname(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    return name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
end

-- Stable per-session numbering: sorted by bufnr (creation order), full
-- listed-buffer list (current buffer included), so a slot only shifts when
-- a buffer is created/deleted, never when you switch buffers.
function M.listed_buffers_sorted()
    local bufs = vim.tbl_filter(function(buf)
        return vim.bo[buf].buflisted
    end, vim.api.nvim_list_bufs())
    table.sort(bufs)
    return bufs
end

function M.switch_to_buf(i)
    local buf = M.listed_buffers_sorted()[i]
    if not buf then
        vim.notify("No buffer " .. i, vim.log.levels.WARN)
        return
    end
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_echo({ { "Switch to Buffer " .. i .. ": " .. M.bufname(buf), "None" } }, false, {})
end

function M.update_clue_descs()
    local ok_clue, miniclue = pcall(require, "mini.clue")
    if not ok_clue then
        return
    end
    local bufs = M.listed_buffers_sorted()
    for i = 1, 9 do
        local buf = bufs[i]
        local desc = buf and ("Switch to " .. M.bufname(buf)) or ("Switch to buffer " .. i)
        for _, mode in ipairs({ "n", "x" }) do
            pcall(miniclue.set_mapping_desc, mode, "<localleader>b" .. i, desc)
        end
    end
end

return M
