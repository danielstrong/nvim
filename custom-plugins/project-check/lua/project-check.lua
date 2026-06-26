local M = {}

local project_check_logs = nil -- shared, append-only log lines (table of strings) for ESLint + TSC, or nil if never run

-- Append a titled, timestamped section to the shared project-check log.
local function append_check_log(tool, lines)
    project_check_logs = project_check_logs or {}
    table.insert(project_check_logs, "=== " .. tool .. " @ " .. os.date("%Y-%m-%d %H:%M:%S") .. " ===")
    vim.list_extend(project_check_logs, lines)
    table.insert(project_check_logs, "")
end

-- Pick the binary runner based on the project's lockfile (falls back to npx).
local function eslint_runner(root)
    if vim.fn.filereadable(root .. "/pnpm-lock.yaml") == 1 then
        return { "pnpm", "exec" }
    elseif vim.fn.filereadable(root .. "/yarn.lock") == 1 then
        return { "yarn", "exec" }
    elseif vim.fn.filereadable(root .. "/bun.lockb") == 1 or vim.fn.filereadable(root .. "/bun.lock") == 1 then
        return { "bun", "x" }
    end
    return { "npx" }
end

local function run_eslint(quiet, on_done)
    local root = vim.fs.root(0, { "package.json" })
    if not root then
        if not on_done then
            vim.notify("No package.json found can not run Project Check", vim.log.levels.ERROR)
        else
            append_check_log("ESLint", { "No package.json found can not run eslint" })
            on_done(false, -1)
        end
        return
    end
    -- if not on_done then
    vim.notify("Running ESLint" .. (quiet and "" or " (include warnings)") .. " in " .. root .. " …", vim.log.levels.INFO)
    -- end
    vim.fn.setqflist({}, "r", { title = "ESLint", items = {} })
    local cmd = vim.list_extend(eslint_runner(root), { "eslint", ".", "--format", "json" })
    if quiet then
        table.insert(cmd, "--quiet")
    end
    local stdout, stderr = {}, {}
    vim.fn.jobstart(cmd, {
        cwd = root,
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data then
                vim.list_extend(stdout, data)
            end
        end,
        on_stderr = function(_, data)
            if data then
                vim.list_extend(stderr, data)
            end
        end,
        on_exit = function(_, code)
            vim.schedule(function()
                local raw = table.concat(stdout, "\n")
                local items = {}
                local ok, results = pcall(vim.json.decode, raw)
                if ok and type(results) == "table" then
                    local sev = { [1] = "W", [2] = "E" }
                    for _, file in ipairs(results) do
                        for _, m in ipairs(file.messages or {}) do
                            table.insert(items, {
                                filename = file.filePath,
                                lnum = m.line or 1,
                                col = m.column or 1,
                                type = sev[m.severity] or "E",
                                text = (m.ruleId and ("[" .. m.ruleId .. "] ") or "") .. (m.message or ""),
                            })
                        end
                    end
                end

                local log = { "$ " .. table.concat(cmd, " ") .. "  (cwd: " .. root .. ", exit " .. code .. ")", "" }
                if #stderr > 0 and not (ok and type(results) == "table") then
                    table.insert(log, "--- stderr ---")
                    vim.list_extend(log, stderr)
                    table.insert(log, "")
                end
                if not ok then
                    table.insert(log, "--- could not parse JSON; raw stdout follows ---")
                    vim.list_extend(log, stdout)
                end
                append_check_log("ESLint", log)

                vim.fn.setqflist({}, "r", { title = "ESLint", items = items })
                if not on_done then
                    if #items > 0 then
                        vim.notify(#items .. " ESLint issue(s) in quickfix", vim.log.levels.WARN)
                    elseif ok then
                        vim.notify("ESLint: no issues", vim.log.levels.INFO)
                    else
                        vim.notify("ESLint failed (<localleader>nl to view log)", vim.log.levels.ERROR)
                    end
                else
                    on_done(ok, #items)
                end
            end)
        end,
    })
end

local function run_tsc(on_done)
    local root = vim.fs.root(0, { "package.json" })
    if not root then
        if not on_done then
            vim.notify("No package.json found can not run Project Check", vim.log.levels.ERROR)
        else
            append_check_log("TSC", { "No package.json found can not run tsc" })
            on_done(10, -1)
        end
        return
    end
    vim.notify("Running tsc --noEmit in " .. root .. " …", vim.log.levels.INFO)
    vim.fn.setqflist({}, "r", { title = "TSC", items = {} })
    local cmd = vim.list_extend(eslint_runner(root), { "tsc", "--noEmit", "--pretty", "false" })
    local stdout, stderr = {}, {}
    vim.fn.jobstart(cmd, {
        cwd = root,
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data then
                vim.list_extend(stdout, data)
            end
        end,
        on_stderr = function(_, data)
            if data then
                vim.list_extend(stderr, data)
            end
        end,
        on_exit = function(_, code)
            vim.schedule(function()
                local sev = { error = "E", warning = "W" }
                local items = {}
                for _, line in ipairs(stdout) do
                    local file, lnum, col, severity, tscode, msg = line:match("^(.-)%((%d+),(%d+)%):%s+(%a+)%s+TS(%d+):%s+(.*)$")
                    if file then
                        if not file:match("^/") then
                            file = root .. "/" .. file
                        end
                        table.insert(items, {
                            filename = file,
                            lnum = tonumber(lnum) or 1,
                            col = tonumber(col) or 1,
                            type = sev[severity] or "E",
                            text = "[TS" .. tscode .. "] " .. msg,
                        })
                    end
                end

                local log = { "$ " .. table.concat(cmd, " ") .. "  (cwd: " .. root .. ", exit " .. code .. ")", "" }
                if #stderr > 0 then
                    table.insert(log, "--- stderr ---")
                    vim.list_extend(log, stderr)
                    table.insert(log, "")
                end
                vim.list_extend(log, stdout)
                append_check_log("TSC", log)

                vim.fn.setqflist({}, "r", { title = "TSC", items = items })
                if not on_done then
                    if #items > 0 then
                        vim.notify(#items .. " TSC issue(s) in quickfix", vim.log.levels.WARN)
                    elseif code == 0 then
                        vim.notify("TSC: no issues", vim.log.levels.INFO)
                    else
                        vim.notify("TSC failed (<localleader>nl to view log)", vim.log.levels.ERROR)
                    end
                else
                    on_done(code, #items)
                end
            end)
        end,
    })
end

-- Run TSC first; only run ESLint if tsc exits cleanly (code 0).
function M.run_checks(quiet)
    vim.notify("Running project checks: tsc, eslint …", vim.log.levels.INFO)
    run_tsc(function(tsc_code, tsc_count)
        if tsc_code ~= 0 then
            if tsc_count >= 0 then
                vim.notify("TSC found " .. tsc_count .. " issue(s); ESLint not run (<localleader>nl for log)", vim.log.levels.ERROR)
            else
                vim.notify("TSC failed; ESLint not run (<localleader>nl for log)", vim.log.levels.ERROR)
            end
            return
        end
        -- vim.notify("TSC clean — running ESLint" .. (quiet and "" or " (include warnings)") .. " …", vim.log.levels.INFO)
        run_eslint(quiet, function(ok, esl_count)
            if not ok then
                vim.notify("TSC no issues; ESLint failed to run (<localleader>nl for log)", vim.log.levels.ERROR)
            elseif esl_count > 0 then
                vim.notify("TSC no issues; ESLint found " .. esl_count .. " issue(s) in quickfix", vim.log.levels.WARN)
            else
                vim.notify("TSC no issues; ESLint no issues", vim.log.levels.INFO)
            end
        end)
    end)
end

function M.view_project_check_logs()
    if not project_check_logs or #project_check_logs == 0 then
        vim.notify("No check logs yet", vim.log.levels.INFO)
        return
    end
    Snacks.win({
        title = " Project Check Output ",
        title_pos = "center",
        text = project_check_logs,
        ft = "log",
        width = 0.8,
        height = 0.8,
        border = "rounded",
        enter = true,
        wo = { number = false, relativenumber = false, wrap = false },
        bo = { modifiable = false, readonly = true },
        keys = { q = "close" },
    })
end
return M
