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
    for client_id, p in pairs(progress) do
        if #p > 0 then
            local client = vim.lsp.get_client_by_id(client_id)
            local name = client and client.name or tostring(client_id)
            local msgs = {}
            for _, item in ipairs(p) do
                table.insert(msgs, item.msg)
            end
            table.insert(parts, string.format("%s %s", name, table.concat(msgs, " ")))
        end
    end
    if #parts == 0 then
        return ""
    end

    local frame = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    return string.format("%s %s", frame, table.concat(parts, " "))
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
                    local percent = value.kind == "end" and 100 or value.percentage or 100
                    local title = value.title or ""
                    local message = ""
                    if value.message then
                        message = ("%s"):format(value.message)
                    end
                    -- local msg = ("(%2d %s%s)"):format(percent, title, message)
                    local msg = percent .. "%%"

                    p[i] = {
                        token = ev.data.params.token,
                        msg = msg,
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
