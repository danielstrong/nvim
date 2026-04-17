-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set

-- Search and Replace
-- to use: yank the replacement text, search the target text, then use this keymap
map("n", "s/", ':%s//\\=@"/gc<CR>', { noremap = true, desc = "Find and replace search incremental" })

-- Incremental Rename
-- to use: put cursor over target word, use this keymap, then type in replacement text
map("n", "srn", 'byiw:%s!<C-r>"!!gc<left><left><left>', { noremap = true, desc = "Find and replace word incremental" })
-- to use: visually select the target word, use this keymap, the type in replacement text
map("v", "srn", '"hy:%s!<C-r>h!!gc<left><left><left>', { noremap = true, desc = "Find and replace visually incremental" })

-- Rename All
-- to use: put cursor over target word, use this keymap, then type in replacement text
map("n", "sra", 'byiw:%s!<C-r>"!!g<left><left>', { noremap = true, desc = "Find and replace word all" })
-- to use: visually select the target word, use this keymap, the type in replacement text
map("v", "sra", '"hy:%s!<C-r>h!!g<left><left>', { noremap = true, desc = "Find and replace visually all" })

map("n", "#", "gcc", { remap = true, desc = "toggle line comment" })
map("v", "#", "gc", { remap = true, desc = "toggle comment" })

map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "X", '"_X')
map("n", "<localleader>v", "<C-v>", { desc = "enter visual block mode" })

map({ "n", "v" }, "<localleader>q", "<cmd>q<cr>", { desc = "quit" })
map({ "n", "v" }, "<localleader>QQ", "<cmd>qa<cr>", { desc = "quit all" })
map({ "n", "v" }, "<localleader>QW", "<cmd>AutoSession save<CR><cmd>wqa<cr>", { desc = "quit all + save session" })

require("which-key").add({
    { "<localleader>d", group = "diagnostics", mode = { "n", "v" } },
    { "<localleader>f", group = "fuzzy", mode = { "n", "v" } },
    { "<localleader>g", group = "git", mode = { "n", "v" } },
    { "<localleader>h", group = "hunk", mode = { "n", "v" } },
    { "<localleader>n", group = "nvim", mode = { "n", "v" } },
    { "<localleader>Q", group = "quit", mode = { "n", "v" } },
    { "<localleader>W", group = "save", mode = { "n", "v" } },
    { "<localleader>t", group = "tabs", mode = { "n", "v" } },
    { "<localleader>s", group = "session", mode = { "n", "v" } },
    { "<localleader>u", group = "ui", mode = { "n", "v" } },
})
map({ "n", "v" }, "<localleader>tn", "<cmd>tabnew<cr>", { desc = "Tab new" })
map({ "n", "v" }, "<localleader>ts", "<cmd>tab split<cr>", { desc = "open current buffer into new tab" })
map({ "n", "v" }, "<localleader>tx", "<cmd>tabclose<cr>", { desc = "Tab close" })
map({ "n", "v" }, "<localleader>tX", "<cmd>tabonly<cr>", { desc = "kill other tabs" })
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

map({ "n", "v" }, "<localleader>x", "<cmd>bn | bd #<cr>", { desc = "kill buffer" })
map({ "n", "v" }, "<localleader>X", "<cmd>%bd |e# | bd#<cr>", { desc = "kill other buffers" })
map({ "n", "v" }, "<localleader>w", "<cmd>w<cr>", { desc = "save" })
map({ "n", "v" }, "<localleader>We", "<cmd>noautocmd w<cr>", { desc = "save without formatting" })
map({ "n", "v" }, "<localleader>Ww", "<cmd>AutoSession save<CR><cmd>wa<cr>", { desc = "save all + save session" })
map({ "n", "v" }, "<localleader>l", "<cmd>e<cr>", { desc = "load file" })
map({ "n", "v" }, "<localleader>L", function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
            vim.api.nvim_buf_call(buf, function()
                vim.cmd("e")
            end)
        end
    end
end, { desc = "reload all buffers" })

map({ "n", "v" }, "<localleader>sw", "<cmd>AutoSession save<CR>", { desc = "Save Session" })
map({ "n", "v" }, "<localleader>sW", ":AutoSession save ", { desc = "Save Session with name" })
map({ "n", "v" }, "<localleader>sr", "<cmd>AutoSession restore<CR>", { desc = "Restore Session" })
map({ "n", "v" }, "<localleader>sR", ":AutoSession restore ", { desc = "Restore Session with name" })
map({ "n", "v" }, "<localleader>se", "<cmd>AutoSession search<CR>", { desc = "Search Session" })
map({ "n", "v" }, "<localleader>sd", "<cmd>AutoSession deletePicker<CR>", { desc = "Delete Session Picker" })
map({ "n", "v" }, "<localleader>sx", "<cmd>AutoSession delete<CR>", { desc = "Delete Session" })
map({ "n", "v" }, "<localleader>sX", ":AutoSession delete ", { desc = "Delete Session with name" })
map({ "n", "v" }, "<localleader>sD", "<cmd>AutoSession purgeOrphaned<CR>", { desc = "Purge Orphaned Session" })
map({ "n", "v" }, "<localleader>st", "<cmd>AutoSession enable<CR>", { desc = "Enable Autosave Session" })
map({ "n", "v" }, "<localleader>sT", "<cmd>AutoSession disable<CR>", { desc = "Disable Autosave Session" })

map("n", "<localleader>nn", "<cmd>messages<cr>", { desc = "Messages" })
map("n", "<localleader>nr", "<cmd>registers<cr>", { desc = "Registers" })
map("n", "<localleader>nj", "<cmd>jumps<cr>", { desc = "Jumps" })
map("n", "<localleader>nm", "<cmd>marks<cr>", { desc = "Marks" })

-- map("n", "<localleader>D", "<cmd>Ex<cr>", { desc = "Explore" })
-- map("n", "<localleader>d", "<cmd>Lexplore<cr>", { desc = "Explore Bar" })

map("n", "<C-j>", "<cmd>m +1<CR>", { desc = "Move line down" })
map("n", "<C-k>", "<cmd>m -2<CR>", { desc = "Move line up" })
map("i", "<C-j>", "<Esc><cmd>m +1<CR>gi", { desc = "Move line down" })
map("i", "<C-k>", "<Esc><cmd>m -2<CR>gi", { desc = "Move line up" })

map("n", "<C-down>", "<cmd>m +1<CR>", { desc = "Move line down" })
map("n", "<C-up>", "<cmd>m -2<CR>", { desc = "Move line up" })
map("i", "<C-down>", "<Esc><cmd>m +1<CR>gi", { desc = "Move line down" })
map("i", "<C-up>", "<Esc><cmd>m -2<CR>gi", { desc = "Move line up" })

map("n", "<CR>", "O<Esc>j", { desc = "Insert blank line above" })
map("v", "<CR>", "y", { desc = "Yank selection" })
map("x", "<localleader>p", '"_dP', { desc = "Paste without yank" })

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

map("n", "S", "s$", { remap = true, desc = "Replace to end of line" })

map("n", "yiy", "my^vg_y`y", { desc = "Yank trimmed line (characterwise)" })

map("n", "<Space>", "i<Space><ESC>l", { desc = "Insert space" })
map("n", "<BS>", "i<BS><Esc>l", { desc = "Delete character before cursor" })

map("i", "<Insert>", "<Esc><Right>", { desc = "Exit insert mode (disable replace)" })

map("n", "<C-w>e", "<cmd>wincmd p<CR>", { silent = true, desc = "Previous window split" })

map("n", "<localleader>c", "<cmd>let @+ = fnamemodify(expand('%'), ':.')<CR><cmd>echo 'Copied: ' . fnamemodify(expand('%'), ':.')<CR>", { desc = "copy relative path" })
map("n", "<localleader>C", "<cmd>let @+ = expand('%:p')<CR><cmd>echo 'Copied: ' . expand('%:p')<CR>", { desc = "copy absolute path" })

-- https://github.com/ibhagwan/fzf-lua
map("n", "z=", "<cmd>FzfLua spell_suggest<cr>", { desc = "Spell Suggest" })

map("n", "<localleader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<localleader>fB", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<localleader>gG", function()
    Snacks.lazygit()
end, { desc = "Lazygit" })
map("n", "<localleader>gg", function()
    Snacks.terminal("gitui")
end, { desc = "GitUI" })
map("n", "<localleader>gb", "<cmd>FzfLua git_blame<cr>", { desc = "Git Blame" })
map("n", "<localleader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Git Commits" })
map("n", "<localleader>gC", "<cmd>FzfLua git_bcommits<cr>", { desc = "Git Commits (buffer)" })
map("n", "<localleader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })
map("n", "<localleader>gw", "<cmd>FzfLua git_worktrees<cr>", { desc = "Git Worktrees" })
map("n", "<localleader>gn", "<cmd>FzfLua git_branches<cr>", { desc = "Git Branches" })
map("n", "<localleader>gr", "<cmd>FzfLua git_stash<cr>", { desc = "Git Stash" })
map("n", "<localleader>gt", "<cmd>FzfLua git_tags<cr>", { desc = "Git Tags" })

map("n", "<localleader>gB", function()
    Snacks.picker.git_log_line()
end, { desc = "Git Blame Line" })
map("n", "<localleader>gS", function()
    Snacks.picker.git_status()
end, { desc = "Git Status" })

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
    :map("<localleader>um")
