-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

map("n", "=zj", "<cmd>%!jq .<CR>", { noremap = true, desc = "Format JSON with jq" })

-- Search and Replace
-- to use: yank the replacement text, search the target text, then use this keymap
map("n", "<localleader>r/", ":%s//<C-r>//gc<left><left><left>", { noremap = true, desc = "Find and replace search" })

-- Incremental Rename
-- to use: put cursor over target word, use this keymap, then type in replacement text
map("n", "<localleader>rn", 'b"hyiw:%s!<C-r>h!!gc<left><left><left><C-r>h', { noremap = true, desc = "Find and replace word incremental" })
-- to use: visually select the target word, use this keymap, the type in replacement text
map("v", "<localleader>rn", '"hy:%s!<C-r>h!!gc<left><left><left><C-r>h', { noremap = true, desc = "Find and replace visually incremental" })

-- Rename All
-- to use: put cursor over target word, use this keymap, then type in replacement text
map("n", "<localleader>ra", 'b"hyiw:%s!<C-r>h!!g<left><left><C-r>h', { noremap = true, desc = "Find and replace word all" })
-- to use: visually select the target word, use this keymap, the type in replacement text
map("v", "<localleader>ra", '"hy:%s!<C-r>h!!g<left><left><C-r>h', { noremap = true, desc = "Find and replace visually all" })

map("n", "#", "gcc", { remap = true, desc = "toggle line comment" })
map("v", "#", "gc", { remap = true, desc = "toggle comment" })

map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "X", '"_X')
map({ "n", "v" }, "<localleader>vb", "<C-v>", { desc = "enter visual block mode" })

map({ "n", "v" }, "<localleader>tn", "<cmd>tabnew<cr>", { desc = "Tab new" })
map({ "n", "v" }, "<localleader>ts", "<cmd>tab split<cr>", { desc = "open current buffer into new tab" })
map({ "n", "v" }, "<localleader>tx", "<cmd>tabclose<cr>", { desc = "Tab close" })
map({ "n", "v" }, "<localleader>tX", "<cmd>tabonly<cr>", { desc = "kill other tabs" })
map({ "n", "v" }, "<localleader>te", "<cmd>tabnext #<cr>", { desc = "navigate tab to last accessed" })
map({ "n", "v" }, "<localleader>t[", "<cmd>tabprev<cr>", { desc = "navigate tab to left" })
map({ "n", "v" }, "<localleader>t]", "<cmd>tabnext<cr>", { desc = "navigate tab to right" })
map({ "n", "v" }, "<localleader>th", "<cmd>tabprev<cr>", { desc = "navigate tab to left" })
map({ "n", "v" }, "<localleader>tl", "<cmd>tabnext<cr>", { desc = "navigate tab to right" })
map({ "n", "v" }, "<localleader>t1", "<cmd>1tabnext<cr>", { desc = "navigate to tab 1" })
map({ "n", "v" }, "<localleader>t2", "<cmd>2tabnext<cr>", { desc = "navigate to tab 2" })
map({ "n", "v" }, "<localleader>t3", "<cmd>3tabnext<cr>", { desc = "navigate to tab 3" })
map({ "n", "v" }, "<localleader>t4", "<cmd>4tabnext<cr>", { desc = "navigate to tab 4" })
map({ "n", "v" }, "<localleader>t5", "<cmd>5tabnext<cr>", { desc = "navigate to tab 5" })
map({ "n", "v" }, "<localleader>t6", "<cmd>6tabnext<cr>", { desc = "navigate to tab 6" })
map({ "n", "v" }, "<localleader>t7", "<cmd>7tabnext<cr>", { desc = "navigate to tab 7" })
map({ "n", "v" }, "<localleader>t8", "<cmd>8tabnext<cr>", { desc = "navigate to tab 8" })
map({ "n", "v" }, "<localleader>t9", "<cmd>9tabnext<cr>", { desc = "navigate to tab 9" })
map({ "n", "v" }, "<localleader>t0", "<cmd>tabfirst<cr>", { desc = "navigate tab first" })
map({ "n", "v" }, "<localleader>t$", "<cmd>tablast<cr>", { desc = "navigate tab last" })
map({ "n", "v" }, "<localleader>tm[", "<cmd>-tabmove<cr>", { desc = "move tab to left" })
map({ "n", "v" }, "<localleader>tm]", "<cmd>+tabmove<cr>", { desc = "move tab to right" })
map({ "n", "v" }, "<localleader>tmh", "<cmd>-tabmove<cr>", { desc = "move tab to left" })
map({ "n", "v" }, "<localleader>tml", "<cmd>+tabmove<cr>", { desc = "move tab to right" })
map({ "n", "v" }, "<localleader>tm1", "<cmd>tabmove 0<cr>", { desc = "move tab to 1" })
map({ "n", "v" }, "<localleader>tm2", "<cmd>tabmove 2<cr>", { desc = "move tab to 2" })
map({ "n", "v" }, "<localleader>tm3", "<cmd>tabmove 3<cr>", { desc = "move tab to 3" })
map({ "n", "v" }, "<localleader>tm4", "<cmd>tabmove 4<cr>", { desc = "move tab to 4" })
map({ "n", "v" }, "<localleader>tm5", "<cmd>tabmove 5<cr>", { desc = "move tab to 5" })
map({ "n", "v" }, "<localleader>tm6", "<cmd>tabmove 6<cr>", { desc = "move tab to 6" })
map({ "n", "v" }, "<localleader>tm7", "<cmd>tabmove 7<cr>", { desc = "move tab to 7" })
map({ "n", "v" }, "<localleader>tm8", "<cmd>tabmove 8<cr>", { desc = "move tab to 8" })
map({ "n", "v" }, "<localleader>tm9", "<cmd>tabmove 9<cr>", { desc = "move tab to 9" })
map({ "n", "v" }, "<localleader>tm0", "<cmd>tabmove 0<cr>", { desc = "move tab to first" })
map({ "n", "v" }, "<localleader>tm$", "<cmd>tabmove $<cr>", { desc = "move tab to end" })
map({ "n", "v" }, "<localleader>tm#", "<cmd>tabmove #<cr>", { desc = "move tab after last accessed" })

map({ "n", "v" }, "<localleader>tr", function()
    local current = vim.t.tab_name or ""
    vim.ui.input({ prompt = "Tab name: ", default = current }, function(name)
        if name == nil then
            return
        end
        vim.t.tab_name = (name ~= "" and name or nil)
        vim.cmd("redrawtabline")
    end)
end, { desc = "Rename tab" })

vim.o.tabline = "%!v:lua.TabLineSplits()"
function _G.TabLine()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local tabnr = i
        local tabpage = vim.api.nvim_list_tabpages()[i]
        local ok, name = pcall(vim.api.nvim_tabpage_get_var, tabpage, "tab_name")
        if not ok then
            name = nil
        end
        if not name or name == "" then
            local buflist = vim.fn.tabpagebuflist(tabnr)
            local winnr = vim.fn.tabpagewinnr(tabnr)
            local bufnr = buflist[winnr]
            local fname = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
            name = (fname ~= "" and fname or "[No Name]")
        end
        local hl = (tabnr == vim.fn.tabpagenr()) and "%#TabLineSel#" or "%#TabLine#"
        s = s .. hl .. "%" .. tabnr .. "T " .. tabnr .. ": " .. name .. " %T"
    end
    return s .. "%#TabLineFill#%T"
end

function _G.TabLineSplits()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local tabnr = i
        local tabpage = vim.api.nvim_list_tabpages()[i]
        local ok, name = pcall(vim.api.nvim_tabpage_get_var, tabpage, "tab_name")
        if not ok then
            name = nil
        end
        if not name or name == "" then
            local names = {}
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
                if vim.api.nvim_win_get_config(win).relative == "" then
                    local bufnr = vim.api.nvim_win_get_buf(win)
                    local ft = vim.bo[bufnr].filetype
                    if ft ~= "NvimTree" then
                        local fname = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
                        table.insert(names, fname ~= "" and fname or "[No Name]")
                    end
                end
            end
            if #names > 1 then
                name = "" .. table.concat(names, " | ") .. ""
            else
                name = names[1] or "[No Name]"
            end
        end
        local hl = (tabnr == vim.fn.tabpagenr()) and "%#TabLineSel#" or "%#TabLine#"
        s = s .. hl .. "%" .. tabnr .. "T " .. tabnr .. ": " .. name .. " %T"
    end
    return s .. "%#TabLineFill#%T"
end

map("n", "<localleader>ws", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<localleader>wv", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<localleader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

local function real_win_count()
    local count = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
            if ft ~= "NvimTree" then
                count = count + 1
            end
        end
    end
    return count
end

local function real_tab_count()
    return vim.fn.tabpagenr("$")
end

local function real_wins_showing_current_buf_count()
    local cur = vim.api.nvim_get_current_buf()
    local showing = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == "" and vim.api.nvim_win_get_buf(win) == cur then
            showing = showing + 1
        end
    end
    return showing
end

local function real_is_only_nvimtree_remaining()
    local count = 0
    local nvimtreecount = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
            if ft ~= "NvimTree" then
                count = count + 1
            else
                nvimtreecount = nvimtreecount + 1
            end
        end
    end
    return count == 0 and nvimtreecount == 1
end

local function real_quit_window()
    vim.cmd("quit")
    if real_is_only_nvimtree_remaining() then
        vim.cmd("quit")
    end
end

local function real_quit_window_without_closing_nvim()
    if real_tab_count() == 1 and real_win_count() == 1 then
        vim.notify("Can't close the last window", vim.log.levels.WARN)
        return
    end
    vim.cmd("quit")
    if real_tab_count() > 1 and real_is_only_nvimtree_remaining() then
        vim.cmd("quit")
    end
end

local function real_delete_buffer_without_closing_nvim()
    if real_tab_count() == 1 and real_win_count() == 1 then
        vim.notify("Can't close the last window", vim.log.levels.WARN)
        return
    end
    if real_wins_showing_current_buf_count() > 1 then
        vim.cmd("quit")
        return
    end
    Snacks.bufdelete()
    if real_tab_count() > 1 and real_is_only_nvimtree_remaining() then
        Snacks.bufdelete()
    end
end

map({ "n", "v" }, "<localleader>q", real_delete_buffer_without_closing_nvim, { desc = "close buffer" })
map({ "n", "v" }, "<localleader>bc", function()
    local shown = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        shown[vim.api.nvim_win_get_buf(win)] = true
    end
    local deleted = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted and not shown[buf] then
            if pcall(vim.api.nvim_buf_delete, buf, { force = false }) then
                deleted = deleted + 1
            end
        end
    end
    vim.notify(("Deleted %d buffer%s"):format(deleted, deleted == 1 and "" or "s"))
end, { desc = "kill unshown buffers" })
map({ "n", "v" }, "<localleader>bx", "<cmd>bn | bd #<cr>", { desc = "kill buffer" })
map({ "n", "v" }, "<localleader>bo", "<cmd>%bd |e# | bd#<cr>", { desc = "only buffer" })
map({ "n", "v" }, "<localleader>l", "<cmd>e<cr>", { desc = "reload buffer" })
map({ "n", "v" }, "<localleader>bl", "<cmd>e<cr>", { desc = "reload buffer" })
map({ "n", "v" }, "<localleader>bD", function()
    Snacks.bufdelete()
end, { desc = "buffer delete" })
map({ "n", "v" }, "<localleader>bd", "<cmd>bd<cr>", { desc = "buffer delete" })
map({ "n", "v" }, "<localleader>be", "<cmd>b#<cr>", { desc = "switch to last buffer" })
local function reload_all_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
            vim.api.nvim_buf_call(buf, function()
                vim.cmd("e")
            end)
        end
    end
end
map({ "n", "v" }, "<localleader>bL", reload_all_buffers, { desc = "reload all buffers" })
map({ "n", "v" }, "<localleader>L", reload_all_buffers, { desc = "reload all buffers" })

map({ "n", "v" }, "ZZ", "<cmd>x<cr>", { desc = "save quit file" })
map({ "n", "v" }, "ZX", real_quit_window, { desc = "quit window" })
map({ "n", "v" }, "ZC", "<cmd>qa<cr>", { desc = "quit all save session" })
map({ "n", "v" }, "ZV", "<cmd>wqa<cr>", { desc = "save quit all" })
map({ "n", "v" }, "ZQ", "<cmd>q<cr>", { desc = "quit window save session" })

map({ "n", "v" }, "<localleader>QQ", "<cmd>AutoSession disable<CR><cmd>qa<cr>", { desc = "quit all disable session" }) -- TODO dont have this save sesion..
map({ "n", "v" }, "<localleader>QA", "<cmd>qa<cr>", { desc = "quit all save session" }) -- TODO dont have this save sesion..
map({ "n", "v" }, "<localleader>QW", "<cmd>wqa<cr>", { desc = "quit save all save session" }) -- TODO dont have this save sesion..
map({ "n", "v" }, "<localleader>x", real_quit_window_without_closing_nvim, { desc = "Close Window" })
map({ "n", "v" }, "<localleader>X", "<cmd>qa<cr>", { desc = "quit all save session" })

map({ "n", "v" }, "<localleader>s", "<cmd>w<cr>", { desc = "Save Buffer" })
map({ "n", "v" }, "<localleader>S", "<cmd>wa<cr>", { desc = "Save All Buffers" })
map({ "n", "v" }, "<localleader>Ws", "<cmd>w<cr>", { desc = "Save Buffer" })
map({ "n", "v" }, "<localleader>WS", "<cmd>wa<cr>", { desc = "Save All Buffers" })
map({ "n", "v" }, "<localleader>We", "<cmd>noautocmd w<cr>", { desc = "save buffer no format" })
map({ "n", "v" }, "<localleader>WE", "<cmd>noautocmd wa<cr>", { desc = "save all files no format" })

map({ "n", "v" }, "<localleader>Nn", "<cmd>messages<cr>", { desc = "Messages" })
map({ "n", "v" }, '<localleader>N"', "<cmd>registers<cr>", { desc = "Registers" })
map({ "n", "v" }, "<localleader>Nj", "<cmd>jumps<cr>", { desc = "Jumps" })
map({ "n", "v" }, "<localleader>N'", "<cmd>marks<cr>", { desc = "Marks" })

-- map("n", "<localleader>D", "<cmd>Ex<cr>", { desc = "Explore" })
-- map("n", "<localleader>d", "<cmd>Lexplore<cr>", { desc = "Explore Bar" })

-- map("n", "<C-j>", "<cmd>m +1<CR>", { desc = "Move line down" })
-- map("n", "<C-k>", "<cmd>m -2<CR>", { desc = "Move line up" })
-- map("i", "<C-j>", "<Esc><cmd>m +1<CR>gi", { desc = "Move line down" })
-- map("i", "<C-k>", "<Esc><cmd>m -2<CR>gi", { desc = "Move line up" })

map("n", "<C-down>", "<cmd>m +1<CR>", { desc = "Move line down" })
map("n", "<C-up>", "<cmd>m -2<CR>", { desc = "Move line up" })
map("i", "<C-down>", "<Esc><cmd>m +1<CR>gi", { desc = "Move line down" })
map("i", "<C-up>", "<Esc><cmd>m -2<CR>gi", { desc = "Move line up" })

map("n", "<CR>", "O<Esc>j", { desc = "Insert blank line above" })
map("v", "<CR>", "y", { desc = "Yank selection" })
-- map("x", "<localleader>p", '"_dP', { desc = "Paste without yank" })

-- Paste forced characterwise (inline).
-- Useful after a linewise yank (yy / Vy) when you want the text inline instead of on its own line.
local function paste_charwise(after)
    local lines = vim.fn.getreg('"', 1, true)
    if #lines == 0 then
        return
    end
    if vim.fn.getregtype('"') == "V" then
        table.insert(lines, "")
    end
    vim.api.nvim_put(lines, "c", after, true)
end

map("n", "zp", function()
    paste_charwise(true)
end, { desc = "Paste characterwise inline" })

map("n", "zP", function()
    paste_charwise(false)
end, { desc = "Paste before characterwise inline" })

map("n", "<Home>", "^", { remap = true, desc = "Go to beginning of line" })
-- map("n", "<Home>", function()
--     local cur_col = vim.fn.col(".")
--     vim.cmd("normal! ^")
--     local first_non_blank_col = vim.fn.col(".")
--
--     if cur_col == first_non_blank_col then
--         vim.cmd("normal! 0")
--     end
-- end, { desc = "Go to beginning of line (smart home)" })

map("n", "S", "s$", { remap = true, desc = "Stamp to end of line" })

-- map("n", "yiy", "my^vg_y`y", { desc = "Yank trimmed line (characterwise)" })
map({ "x", "o" }, "iy", function()
    vim.cmd("normal! ^")
    vim.cmd("normal! v")
    vim.cmd("normal! g_")
end, { desc = "Text object: trimmed line content" })

map({ "x", "o" }, "ay", function()
    vim.cmd("normal! 0")
    vim.cmd("normal! v")
    vim.cmd("normal! g_")
end, { desc = "Text object: full line content (characterwise, no newline)" })

map({ "x", "o" }, "ae", function()
    vim.cmd("normal! ggVG")
end, { desc = "Text object: entire file" })

map({ "x", "o" }, "ie", function()
    local first = vim.fn.nextnonblank(1)
    local last = vim.fn.prevnonblank(vim.fn.line("$"))
    if first == 0 or last == 0 then
        return
    end
    vim.fn.cursor(first, 1)
    vim.cmd("normal! V")
    vim.fn.cursor(last, 1)
end, { desc = "Text object: entire file (trimmed)" })

map("n", "<Space>", "i<Space><ESC>l", { desc = "Insert space" })
map("n", "<BS>", "i<BS><Esc>l", { desc = "Delete character before cursor" })

map("i", "<Insert>", "<Esc><Right>", { desc = "Exit insert mode (disable replace)" })

map("n", "<C-w>e", "<cmd>wincmd p<CR>", { silent = true, desc = "Previous window split" })

-- map("n", "<localleader>c", "<cmd>let @+ = fnamemodify(expand('%'), ':.')<CR><cmd>echo 'Copied: ' . fnamemodify(expand('%'), ':.')<CR>", { desc = "copy relative path" })
-- map("n", "<localleader>C", "<cmd>let @+ = expand('%:p')<CR><cmd>echo 'Copied: ' . expand('%:p')<CR>", { desc = "copy absolute path" })
map("n", "<localleader>c", function()
    local rel = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
    vim.fn.setreg("+", rel)
    vim.notify("Copied: " .. rel)
end, { desc = "copy relative path" })
map("n", "<localleader>C", function()
    local abs = vim.fn.expand("%:p")
    vim.fn.setreg("+", abs)
    vim.notify("Copied: " .. abs)
end, { desc = "copy absolute path" })

map("n", "crt", '"_ciwtrue<Esc>', { desc = "Replace word with true" })
map("n", "crf", '"_ciwfalse<Esc>', { desc = "Replace word with false" })
map("n", "crn", '"_ciwnull<Esc>', { desc = "Replace word with null" })
map("n", "cru", '"_ciwundefined<Esc>', { desc = "Replace word with undefined" })
map("n", "cr0", '"_ciw0<Esc>', { desc = "Replace word with 0" })
map("n", "cr`", '"_ciw0<Esc>', { desc = "Replace word with 0" })
map("n", "cr1", '"_ciw1<Esc>', { desc = "Replace word with 1" })

map("n", "<localleader>nQ", function()
    vim.diagnostic.setqflist({ open = false })
    local count = #vim.fn.getqflist()
    vim.notify(count .. " diagnostics in quickfix", vim.log.levels.INFO)
end, { desc = "Diagnostics to Quickfix" })
map("n", "<localleader>nq", function()
    local qf_open = false
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_open = true
            break
        end
    end
    vim.cmd(qf_open and "cclose" or "copen")
end, { desc = "Toggle Quickfix" })

map("n", "<localleader>kl", "<cmd>Trouble lsp_left toggle<cr>", { desc = "LSP Toggle" })
map("n", "<localleader>kr", "<cmd>Trouble lsp_references_left toggle<cr>", { desc = "LSP References" })
map("n", "<localleader>kd", "<cmd>Trouble lsp_definitions_left toggle<cr>", { desc = "LSP Definitions" })
map("n", "<localleader>kD", "<cmd>Trouble lsp_declarations_left toggle<cr>", { desc = "LSP Declarations" })
map("n", "<localleader>ky", "<cmd>Trouble lsp_type_definitions_left toggle<cr>", { desc = "LSP Type Definitions" })
map("n", "<localleader>kI", "<cmd>Trouble lsp_implementations_left toggle<cr>", { desc = "LSP Implementations" })
-- map("n", "<localleader>ko", "<cmd>Trouble lsp_command toggle win.position=left<cr>", { desc = "LSP Command" })

map("n", "<localleader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "H", function()
    local bufnr, win = vim.diagnostic.open_float()
    if bufnr and win then
        vim.keymap.set("n", "H", function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end, { buffer = bufnr, nowait = true, desc = "Close Line Diagnostics" })
    end
end, { desc = "Line Diagnostics" })

map("n", "<localleader>da", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble Workspae Diagnostics" })
map("n", "<localleader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble Buffer Diagnostics" })
map("n", "<localleader>dL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble Location List" })
map("n", "<localleader>dq", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble Quickfix List" })
map("n", "<localleader>dt", "<cmd>Trouble todo toggle<cr>", { desc = "Trouble Todo" })
map("n", "<localleader>dT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", { desc = "Trouble TODO/FIX/FIXME Filtered" })
map("n", "<localleader>dc", function()
    local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
    if #diags == 0 then
        vim.notify("No diagnostics on this line", vim.log.levels.INFO)
        return
    end
    local messages = {}
    for i, d in ipairs(diags) do
        local suffix = d.code and (" [" .. d.code .. "]") or ""
        local line = d.message .. suffix
        if #diags > 1 then
            line = i .. ". " .. line
        end
        messages[i] = line
    end
    local text = table.concat(messages, "\n")
    vim.fn.setreg("+", text)
    local preview = #messages > 1 and (messages[1] .. " …") or text
    vim.notify("Copied: " .. preview, vim.log.levels.INFO)
end, { desc = "Copy Line Diagnostics" })
local eslint_output_logs = nil -- last run's full log lines (table of strings), or nil if never run

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

local function run_eslint(quiet)
    local root = vim.fs.root(0, { ".git", "package.json" }) or vim.fn.getcwd()
    vim.notify("Running ESLint" .. (quiet and "" or " (include warnings)") .. " in " .. root .. " …", vim.log.levels.INFO)
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
                eslint_output_logs = log

                vim.fn.setqflist({}, "r", { title = "ESLint", items = items })
                if #items > 0 then
                    vim.notify(#items .. " ESLint issue(s) in quickfix", vim.log.levels.WARN)
                elseif ok then
                    vim.notify("ESLint: no issues", vim.log.levels.INFO)
                else
                    vim.notify("ESLint failed (<localleader>nl to view log)", vim.log.levels.ERROR)
                end
            end)
        end,
    })
end

map("n", "<localleader>ds", function()
    run_eslint(true)
end, { desc = "ESLint project to Quickfix" })

map("n", "<localleader>dS", function()
    run_eslint(false)
end, { desc = "ESLint project to Quickfix (include warnings)" })

map("n", "<localleader>nl", function()
    if not eslint_output_logs or #eslint_output_logs == 0 then
        vim.notify("No ESLint logs yet", vim.log.levels.INFO)
        return
    end
    Snacks.win({
        title = " ESLint Output ",
        title_pos = "center",
        text = eslint_output_logs,
        ft = "log",
        width = 0.8,
        height = 0.8,
        border = "rounded",
        enter = true,
        wo = { number = false, relativenumber = false, wrap = false },
        bo = { modifiable = false, readonly = true },
        keys = { q = "close" },
    })
end, { desc = "View ESLint logs" })

map("n", "<localleader>fB", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<localleader>ae", function()
    vim.cmd("write")
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end
    local q = vim.fn.shellescape(file)
    Snacks.terminal({ "sh", "-c", "chmod +x " .. q .. " && " .. q })
end, { desc = "Execute file as script" })
map("n", "<localleader>gG", function()
    Snacks.lazygit()
end, { desc = "Lazygit" })
map("n", "<localleader>gg", function()
    Snacks.terminal("gitui")
end, { desc = "GitUI" })

map("n", "<localleader>gB", Snacks.picker.git_log_line, { desc = "Git Blame Line" })
map("n", "<localleader>gS", Snacks.picker.git_status, { desc = "Git Status" })

Snacks.toggle
    .new({
        name = "ESLint",
        get = function()
            return #vim.lsp.get_clients({ name = "eslint", bufnr = 0 }) > 0
        end,
        set = function(state)
            if state then
                vim.cmd("LspStart eslint")
            else
                vim.lsp.stop_client(vim.lsp.get_clients({ name = "eslint", bufnr = 0 }))
            end
        end,
    })
    :map("<localleader>ul")

Snacks.toggle
    .new({
        name = "Codelens",
        get = function()
            return vim.lsp.codelens.is_enabled()
        end,
        set = function(state)
            vim.lsp.codelens.enable(state)
        end,
    })
    :map("<localleader>ur")

Snacks.toggle
    .new({
        name = "Word Wrap",
        get = function()
            return vim.wo.wrap
        end,
        set = function(state)
            vim.wo.wrap = state
        end,
    })
    :map("<localleader>uw")

Snacks.toggle
    .new({
        name = "Spelling",
        get = function()
            return vim.wo.spell
        end,
        set = function(state)
            vim.wo.spell = state
        end,
    })
    :map("<localleader>us")

Snacks.toggle
    .new({
        name = "Force Statusline",
        get = function()
            return vim.o.laststatus == 2
        end,
        set = function(state)
            vim.o.laststatus = state and 2 or 1
        end,
    })
    :map("<localleader>uf")

Snacks.toggle
    .new({
        name = "Mouse",
        get = function()
            return vim.wo.number or vim.wo.relativenumber
        end,
        set = function(state)
            if vim.g.original_signcolumn == nil then
                vim.g.original_signcolumn = vim.wo.signcolumn
                vim.g.original_relativenumber = vim.wo.relativenumber
            end

            if state then
                vim.wo.number = true
                vim.wo.relativenumber = vim.g.original_relativenumber
                vim.o.mouse = "a"
                vim.wo.signcolumn = vim.g.original_signcolumn
            else
                vim.wo.number = false
                vim.wo.relativenumber = false
                vim.wo.signcolumn = "no"
                vim.o.mouse = ""
            end
        end,
    })
    :map("<localleader>uc")
--
Snacks.toggle.zoom():map("<localleader>wz"):map("<localleader>uZ")
Snacks.toggle.zen():map("<localleader>uz")
Snacks.toggle.profiler():map("<leader>pp")
Snacks.toggle.profiler_highlights():map("<leader>ph")
map({ "n" }, "<leader>ps", function()
    Snacks.profiler.scratch()
end, { desc = "Profiler Scratch Bufer" })

do
    local rm = require("nvim-treesitter-textobjects.repeatable_move")

    -- ; / , repeat whichever move (bracket motion or f/F/t/T) ran last.
    map({ "n", "x", "o" }, ";", rm.repeat_last_move_next, { desc = "Repeat last move" })
    map({ "n", "x", "o" }, ",", rm.repeat_last_move_previous, { desc = "Repeat last move (opposite)" })

    -- f/F/t/T record themselves as the last move, then native char-search.
    map({ "n", "x", "o" }, "f", rm.builtin_f_expr, { expr = true, desc = "Find char forward" })
    map({ "n", "x", "o" }, "F", rm.builtin_F_expr, { expr = true, desc = "Find char backward" })
    map({ "n", "x", "o" }, "t", rm.builtin_t_expr, { expr = true, desc = "Till char forward" })
    map({ "n", "x", "o" }, "T", rm.builtin_T_expr, { expr = true, desc = "Till char backward" })

    -- diagnostic
    local diagnostic_goto = function(next, severity)
        return function()
            vim.diagnostic.jump({
                count = (next and 1 or -1) * vim.v.count1,
                severity = severity and vim.diagnostic.severity[severity] or nil,
                float = true,
            })
        end
    end

    local repeat_move = require("repeatable_move")
    local repeatable_next_diag, repeatable_prev_diag = repeat_move.make_repeatable_move_pair(diagnostic_goto(true), diagnostic_goto(false))
    local repeatable_next_diag_error, repeatable_prev_diag_error = repeat_move.make_repeatable_move_pair(diagnostic_goto(true, "ERROR"), diagnostic_goto(false, "ERROR"))
    local repeatable_next_diag_warn, repeatable_prev_diag_warn = repeat_move.make_repeatable_move_pair(diagnostic_goto(true, "WARN"), diagnostic_goto(false, "WARN"))

    map({ "n", "x", "o" }, "]d", repeatable_next_diag, { desc = "Next Diagnostic" })
    map({ "n", "x", "o" }, "[d", repeatable_prev_diag, { desc = "Prev Diagnostic" })
    map({ "n", "x", "o" }, "]e", repeatable_next_diag_error, { desc = "Next Error" })
    map({ "n", "x", "o" }, "[e", repeatable_prev_diag_error, { desc = "Prev Error" })
    map({ "n", "x", "o" }, "]w", repeatable_next_diag_warn, { desc = "Next Warning" })
    map({ "n", "x", "o" }, "[w", repeatable_prev_diag_warn, { desc = "Prev Warning" })

    -- Turn whatever is currently mapped to [q / ]q into a repeatable pair,
    -- without hardcoding the underlying action.
    local function resolve_map_fn(lhs)
        local m = vim.fn.maparg(lhs, "n", false, true)
        if type(m) == "table" and m.callback then
            return m.callback
        elseif type(m) == "table" and m.rhs and m.rhs ~= "" then
            local keys = vim.api.nvim_replace_termcodes(m.rhs, true, true, true)
            local mode = m.noremap == 1 and "n" or "m"
            return function()
                vim.api.nvim_feedkeys(keys, mode, false)
            end
        end
        local keys = vim.api.nvim_replace_termcodes(lhs, true, true, true)
        return function()
            vim.api.nvim_feedkeys(keys, "n", false)
        end
    end
    local function map_desc(lhs)
        local m = vim.fn.maparg(lhs, "n", false, true)
        return type(m) == "table" and m.desc or nil
    end
    local function map_modes(lhs)
        local modes = {}
        for _, mode in ipairs({ "n", "x", "o" }) do
            local m = vim.fn.maparg(lhs, mode, false, true)
            if type(m) == "table" and next(m) ~= nil then
                table.insert(modes, mode)
            end
        end
        return #modes > 0 and modes or { "n" }
    end

    local function make_mappings_repeatable(next_keymap, prev_keymap)
        local repeatable_next_qf, repeatable_prev_qf = repeat_move.make_repeatable_move_pair(resolve_map_fn(next_keymap), resolve_map_fn(prev_keymap))
        map(map_modes(next_keymap), next_keymap, repeatable_next_qf, { desc = map_desc(next_keymap) })
        map(map_modes(prev_keymap), prev_keymap, repeatable_prev_qf, { desc = map_desc(prev_keymap) })
    end
    local function make_bracket_mappings_repeatable(nextprev_keymap)
        make_mappings_repeatable("]" .. nextprev_keymap, "[" .. nextprev_keymap)
    end
    make_bracket_mappings_repeatable("L")
    make_bracket_mappings_repeatable("M")
    make_bracket_mappings_repeatable("Q")
    make_bracket_mappings_repeatable("T")
    make_bracket_mappings_repeatable("b")
    make_bracket_mappings_repeatable("l")
    make_bracket_mappings_repeatable("m")
    make_bracket_mappings_repeatable("q")
    make_bracket_mappings_repeatable("s")
    make_bracket_mappings_repeatable("t")
    make_mappings_repeatable("gt", "gT")
    -- local repeatable_next_qf, repeatable_prev_qf = repeat_move.make_repeatable_move_pair(resolve_map_fn("]q"), resolve_map_fn("[q"))
    -- map(map_modes("]q"), "]q", repeatable_next_qf, { desc = map_desc("]q") })
    -- map(map_modes("[q"), "[q", repeatable_prev_qf, { desc = map_desc("[q") })

    -- local repeatable_next_todo, repeatable_prev_todo = repeat_move.make_repeatable_move_pair(resolve_map_fn("]t"), resolve_map_fn("[t"))
    -- map(map_modes("]t"), "]t", repeatable_next_todo, { desc = map_desc("]t") })
    -- map(map_modes("[t"), "[t", repeatable_prev_todo, { desc = map_desc("[t") })
end
