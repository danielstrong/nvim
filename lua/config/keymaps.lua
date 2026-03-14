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

map("n", "<localleader>q", "<cmd>q<cr>", { desc = "close buffer" })
map("v", "<localleader>q", "<cmd>q<cr>", { desc = "close buffer" })
map("n", "<localleader>w", "<cmd>w<cr>", { desc = "save file" })
map("v", "<localleader>w", "<cmd>w<cr>", { desc = "save file" })

map("n", "<localleader>n", "<cmd>messages<cr>", { desc = "Messages" })
map("n", "<localleader>r", "<cmd>registers<cr>", { desc = "Registers" })
map("n", "<localleader>j", "<cmd>jumps<cr>", { desc = "Jumps" })
map("n", "<localleader>m", "<cmd>marks<cr>", { desc = "Marks" })

-- map("n", "<localleader>D", "<cmd>Ex<cr>", { desc = "Explore" })
-- map("n", "<localleader>d", "<cmd>Lexplore<cr>", { desc = "Explore Bar" })

vim.cmd([[
nnoremap <C-j> :m +1<CR>
nnoremap <C-k> :m -2<CR>
inoremap <C-j> <Esc>:m +1<CR>gi
inoremap <C-k> <Esc>:m -2<CR>gi

nnoremap <C-down> :m +1<CR>
nnoremap <C-up> :m -2<CR>
inoremap <C-down> <Esc>:m +1<CR>gi
inoremap <C-up> <Esc>:m -2<CR>gi

nnoremap <Cr> O<Esc>j
vnoremap <Cr> y

nnoremap <Space> i<Space><ESC>l
nnoremap <BS> i<BS><esc>l

""" Keep replace mode from being activated

inoremap <Insert> <Esc><Right>

""" Move to previous window split
nnoremap <silent> <c-w>e :wincmd p<CR>


""" Toggle line numbering
nnoremap <F12> :call ChangeLineNumbering()<CR> 
function! ChangeLineNumbering()
	if !exists('g:original_signcolumn')
		let g:original_signcolumn = &signcolumn
	endif

	if &number || &relativenumber
		set nonumber
		set norelativenumber
		set signcolumn=no
		set mouse=
	else
		set number
		set relativenumber
		set mouse=a
		execute 'set signcolumn='.g:original_signcolumn
	endif
endfunction




]])
