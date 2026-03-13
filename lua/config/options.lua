-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.autoread = false
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.backup = false
opt.writebackup = false
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatexpr = "v:lua.LazyVim.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" --nosplit -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 1 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.swapfile = false
opt.relativenumber = true -- Relative line numbers
opt.ruler = true -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
--vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ S = false, W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.filetype.add({
  extension = {
    env = "sh",
    -- cls = "apexcode",
    -- apex = "apexcode",
    -- page = "visualforce",
  },
  filename = {
    [".env"] = "sh",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
  },
})

-- vim.api.nvim_set_hl(0, "StatusLine", { fg = "#090909", bg = "#cccccc" })
-- vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#090909", bg = "#cccccc" })
-- vim.api.nvim_set_hl(0, "Conceal", { fg = "#090909", bg = "#cccccc" })
-- vim.api.nvim_set_hl(0, "StatusLineSection", { fg = "#090909", bg = "#cccccc" })
-- vim.api.nvim_set_hl(0, "StatusLineSectionV", { fg = "#090909", bg = "#f4bf75" })
-- vim.api.nvim_set_hl(0, "StatusLineSectionI", { fg = "#090909", bg = "#90a959" })
-- vim.api.nvim_set_hl(0, "StatusLineSectionC", { fg = "#090909", bg = "#6a9fb5" })
-- vim.api.nvim_set_hl(0, "StatusLineSectionR", { fg = "#090909", bg = "#aac474" })

-- vim.cmd([[
--
-- 		colorscheme hybrid
-- 		"colorscheme codedark
-- 		hi StatusLine         ctermbg=darkgray ctermfg=black guibg=#cccccc guifg=#090909
-- 		hi StatusLineNC       ctermbg=black ctermfg=darkgray guibg=#cccccc guifg=#090909
-- 		hi StatusLineSection  ctermbg=darkgray ctermfg=black guibg=#cccccc guifg=#090909
-- 		hi StatusLineSectionV ctermbg=darkyellow ctermfg=black guibg=#f4bf75 guifg=#090909
-- 		hi StatusLineSectionI ctermbg=darkgreen ctermfg=black guibg=#90a959 guifg=#090909
-- 		hi StatusLineSectionC ctermbg=darkblue ctermfg=black guibg=#6a9fb5 guifg=#090909
-- 		hi StatusLineSectionR ctermbg=green ctermfg=black guibg=#aac474 guifg=#090909
-- 		hi Conceal cterm=underline ctermbg=black ctermfg=lightgray term=underline guibg=#090909 guifg=#cccccc
--  ]])
--

vim.cmd([[

let g:mode_colors = {'n':'StatusLineSection', 'v':'StatusLineSectionV', '^V': 'StatusLineSectionV', 'i':  'StatusLineSectionI', 'c':  'StatusLineSectionC', 'r':  'StatusLineSectionR'}

"let g:statusline_left = '%f %h%m%r'
let g:statusline_left = '[%n]%#StatusLine# %<%f%r%h%m%w'
" let g:statusline_right = ' [%{&ff}] [%{&fileencoding}] %y %=%-14.(%l,%c%V%)%P '
let g:statusline_extra_right = ''

function! StatusLineRenderer()
	let hl = '%#' . get(g:mode_colors, tolower(mode()), g:mode_colors.n) . '#'
	return  hl.g:statusline_left .' %='. g:statusline_extra_right.' %y %-14.(%l,%c%V%)%P '
endfunction

" only set default statusline once on initial startup. ignored on subsequent 'so $MYVIMRC' calls to prevent active buffer statusline from being 'blurred'.
if has('vim_starting')
	let &statusline = g:statusline_left
endif

augroup statusline_update
	au!
	" show focussed buffer statusline
	au FocusGained,VimEnter,WinEnter,BufWinEnter * setlocal statusline=%!StatusLineRenderer()

	" show blurred buffer statusline
	au FocusLost,VimLeave,WinLeave * setlocal statusline&
	"au FocusLost,VimLeave,WinLeave,BufWinLeave * setlocal statusline=%!StatusLineRenderer()

augroup END


""" Toggle laststatus between 1 and 2
function! <SID>ToggleLastStatus()
	if &laststatus == 2
		set laststatus=1
	else
		set laststatus=2
	endif
endfunction
nnoremap <silent> <F9> :<C-u>call <SID>ToggleLastStatus()<CR>
vnoremap <silent> <F9> <Esc>:call <SID>ToggleLastStatus()<CR>v
inoremap <silent> <F9> <Esc>:call <SID>ToggleLastStatus()<CR>i<Right>

]])
