-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set

map("n", "#", "gcc", { remap = true, desc = "toggle line comment" })
map("v", "#", "gc", { remap = true, desc = "toggle comment" })
map(
    "n",
    "<localleader>c",
    "<cmd>let @+ = fnamemodify(expand('%'), ':.')<CR><cmd>echo 'Copied: ' . fnamemodify(expand('%'), ':.')<CR>",
    { desc = "copy relative path" }
)
map("n", "<localleader>C", "<cmd>let @+ = expand('%:p')<CR><cmd>echo 'Copied: ' . expand('%:p')<CR>", { desc = "copy absolute path" })

map("n", "<localleader>v", "<C-v>", { desc = "enter visual block mode" })

map("n", "<localleader>QA", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<localleader>QW", "<cmd>wqa<cr>", { desc = "Save Quit all" })
map("n", "<localleader>QQ", "<cmd>q<cr>", { desc = "close buffer" })
map("v", "<localleader>QQ", "<cmd>q<cr>", { desc = "close buffer" })
map("n", "<localleader>w", "<cmd>w<cr>", { desc = "save file" })
map("v", "<localleader>w", "<cmd>w<cr>", { desc = "save file" })
map("n", "<localleader>l", "<cmd>e<cr>", { desc = "load file" })
map("v", "<localleader>l", "<cmd>e<cr>", { desc = "load file" })

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

map("n", "<Space>", "i<Space><ESC>l", { desc = "Insert space" })
map("n", "<BS>", "i<BS><Esc>l", { desc = "Delete character before cursor" })

map("i", "<Insert>", "<Esc><Right>", { desc = "Exit insert mode (disable replace)" })

map("n", "<C-w>e", "<cmd>wincmd p<CR>", { silent = true, desc = "Previous window split" })

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
