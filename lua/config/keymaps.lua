-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set

map("n", "#", "gcc", { remap = true, desc = "toggle line comment" })
map("v", "#", "gc", { remap = true, desc = "toggle comment" })

map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "X", '"_X')
map("n", "<localleader>v", "<C-v>", { desc = "enter visual block mode" })

map({ "n", "v" }, "<localleader>q", "<cmd>q<cr>", { desc = "quit" })
map({ "n", "v" }, "<localleader>QQ", "<cmd>qa<cr>", { desc = "quit all" })
map({ "n", "v" }, "<localleader>QW", "<cmd>AutoSession save<CR><cmd>wqa<cr>", { desc = "quit all" })
map({ "n", "v" }, "<localleader>x", "<cmd>bn | bd #<cr>", { desc = "kill buffer" })
map({ "n", "v" }, "<localleader>w", "<cmd>w<cr>", { desc = "save" })
map({ "n", "v" }, "<localleader>W", "<cmd>AutoSession save<CR><cmd>wa<cr>", { desc = "save all" })
map({ "n", "v" }, "<localleader>l", "<cmd>e<cr>", { desc = "load file" })

map({ "n", "v" }, "<localleader>sw", "<cmd>AutoSession save<CR>", { desc = "Save Session" })
map({ "n", "v" }, "<localleader>sW", "<cmd>AutoSession save ", { desc = "Save Session with name" })
map({ "n", "v" }, "<localleader>sr", "<cmd>AutoSession restore<CR>", { desc = "Restore Session" })
map({ "n", "v" }, "<localleader>sR", "<cmd>AutoSession restore ", { desc = "Restore Session with name" })
map({ "n", "v" }, "<localleader>se", "<cmd>AutoSession search<CR>", { desc = "Search Session" })
map({ "n", "v" }, "<localleader>sd", "<cmd>AutoSession deletePicker<CR>", { desc = "Delete Session Picker" })
map({ "n", "v" }, "<localleader>sx", "<cmd>AutoSession delete<CR>", { desc = "Delete Session" })
map({ "n", "v" }, "<localleader>sX", "<cmd>AutoSession delete ", { desc = "Delete Session with name" })
map({ "n", "v" }, "<localleader>sD", "<cmd>AutoSession purgeOrphaned<CR>", { desc = "Purge Orphaned Session" })
map({ "n", "v" }, "<localleader>st", "<cmd>AutoSession enable<CR>", { desc = "Enable Autosave Session" })
map({ "n", "v" }, "<localleader>sT", "<cmd>AutoSession disable<CR>", { desc = "Disable Autosave Session" })

map("n", "<localleader>n", "<cmd>messages<cr>", { desc = "Messages" })
map("n", "<localleader>r", "<cmd>registers<cr>", { desc = "Registers" })
map("n", "<localleader>j", "<cmd>jumps<cr>", { desc = "Jumps" })
map("n", "<localleader>m", "<cmd>marks<cr>", { desc = "Marks" })

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

map("n", "<Space>", "i<Space><ESC>l", { desc = "Insert space" })
map("n", "<BS>", "i<BS><Esc>l", { desc = "Delete character before cursor" })

map("i", "<Insert>", "<Esc><Right>", { desc = "Exit insert mode (disable replace)" })

map("n", "<C-w>e", "<cmd>wincmd p<CR>", { silent = true, desc = "Previous window split" })

map("n", "<localleader>c", "<cmd>let @+ = fnamemodify(expand('%'), ':.')<CR><cmd>echo 'Copied: ' . fnamemodify(expand('%'), ':.')<CR>", { desc = "copy relative path" })
map("n", "<localleader>C", "<cmd>let @+ = expand('%:p')<CR><cmd>echo 'Copied: ' . expand('%:p')<CR>", { desc = "copy absolute path" })

map("n", "<localleader>gb", "<cmd>FzfLua git_blame<cr>", { desc = "Git Blame" })
map("n", "<localleader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })

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

map("n", "<F12>", function()
    if vim.g.original_signcolumn == nil then
        vim.g.original_signcolumn = vim.wo.signcolumn
    end

    if vim.wo.number or vim.wo.relativenumber then
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
        vim.o.mouse = ""
    else
        vim.wo.number = true
        vim.wo.relativenumber = true
        vim.o.mouse = "a"
        vim.wo.signcolumn = vim.g.original_signcolumn
    end
end, { desc = "Toggle line numbering" })
