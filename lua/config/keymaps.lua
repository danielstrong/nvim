-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
vim.keymap.set("n", "#", "gcc", { remap = true })
vim.keymap.set("v", "#", "gc", { remap = true })
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

""" alternate way to enter visual block mode to deal with terminal emulators
nnoremap <leader>v <C-v>

""" Save File
nnoremap <leader>ws :w<CR>
vnoremap <leader>ws :w<CR>

""" Move to previous window split
nnoremap <silent> <c-w>e :wincmd p<CR>

""" Open Explorer
nnoremap <leader>D :Ex<CR>
nnoremap <leader>d :Lexplore<CR>


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



nnoremap <leader>m :messages<CR>
nnoremap <leader>r :registers<CR>
"nnoremap <leader>b :buffers<CR>
nnoremap <leader>j :jumps<CR>
nnoremap <leader>m :marks<CR>

""" Copy relative path
"nnoremap <leader>c :let @+ = expand('%')<CR>:echo 'Copied: ' . expand('%')<CR>
nnoremap <leader>'c :let @+ = fnamemodify(expand('%'), ':.')<CR>:echo 'Copied: ' . fnamemodify(expand('%'), ':.')<CR>

""" Copy absolute path
nnoremap <leader>'C :let @+ = expand('%:p')<CR>:echo 'Copied: ' . expand('%:p')<CR>

]])
