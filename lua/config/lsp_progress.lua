local M = {}

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local timer = nil

local function has_active()
    for _, p in pairs(progress) do
        if #p > 0 then
            return true
        end
    end
    return false
end

local function stop_timer()
    if timer then
        timer:stop()
        timer:close()
        timer = nil
    end
end

local function start_timer()
    if timer then
        return
    end
    timer = vim.uv.new_timer()
    timer:start(0, 100, function()
        vim.schedule(function()
            if not has_active() then
                stop_timer()
            end
            vim.cmd.redrawstatus()
        end)
    end)
end

function M.status()
    if not has_active() then
        return ""
    end

    local parts = {}
    for _, p in pairs(progress) do
        for _, item in ipairs(p) do
            table.insert(parts, item.msg)
        end
    end
    if #parts == 0 then
        return ""
    end

    local frame = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    return string.format("%s %s ", frame, table.concat(parts, " "))
end

function M.setup()
    vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
            if not client or type(value) ~= "table" then
                return
            end
            local p = progress[client.id]

            for i = 1, #p + 1 do
                if i == #p + 1 or p[i].token == ev.data.params.token then
                    p[i] = {
                        token = ev.data.params.token,
                        msg = ("[%3d%%] %s%s"):format(value.kind == "end" and 100 or value.percentage or 100, value.title or "", value.message and (" **%s**"):format(value.message) or ""),
                        done = value.kind == "end",
                    }
                    break
                end
            end

            progress[client.id] = vim.tbl_filter(function(v)
                return not v.done
            end, p)

            if has_active() then
                start_timer()
            end
            vim.cmd.redrawstatus()
        end,
    })
end

return M
