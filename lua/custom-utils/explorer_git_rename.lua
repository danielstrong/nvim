local M = {}

function M.rename(picker, item)
    item = item or picker:current()
    if not item then
        return
    end
    local from = vim.fn.fnamemodify(item.file, ":p")
    local root = Snacks.git.get_root(from)
    if not root then
        Snacks.notify.warn("`R` only works inside a git repo. Use `r` to rename instead.")
        return
    end

    local cwd = svim.fs.normalize(vim.fn.getcwd(0))
    local base = from:find(cwd, 1, true) == 1 and cwd or vim.fs.dirname(from)
    local extra = from:sub(#base + 2)

    vim.ui.input({
        prompt = "New File Name (git mv): ",
        default = extra,
        completion = "file",
    }, function(value)
        if not value or value == "" or value == extra then
            return
        end
        local to = svim.fs.normalize(base .. "/" .. value)

        Snacks.rename.on_rename_file(from, to, function()
            vim.fn.mkdir(vim.fs.dirname(to), "p")
            local result = vim.system({ "git", "-C", root, "mv", "--", from, to }):wait()
            if result.code ~= 0 then
                Snacks.notify.error("git mv failed:\n```\n" .. (result.stderr or "") .. "\n```")
                return
            end

            -- rebind any open buffer from the old path to the new one
            local from_buf = vim.fn.bufnr(from)
            if from_buf >= 0 then
                local to_buf = vim.fn.bufadd(to)
                vim.bo[to_buf].buflisted = true
                for _, win in ipairs(vim.fn.win_findbuf(from_buf)) do
                    vim.api.nvim_win_call(win, function()
                        vim.cmd("buffer " .. to_buf)
                    end)
                end
                vim.api.nvim_buf_delete(from_buf, { force = true })
            end

            local Tree = require("snacks.explorer.tree")
            Tree:refresh(vim.fs.dirname(from))
            Tree:refresh(vim.fs.dirname(to))
            require("snacks.explorer.actions").update(picker, { target = to })
        end)
    end)
end

return M
