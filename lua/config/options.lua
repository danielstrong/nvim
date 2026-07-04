-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = "|"
vim.g.maplocalleader = "\\"

vim.g.snacks_animate = false
-- vim.g.lazyvim_ui_statuscolumn = false
vim.g.lazyvim_picker = "fzf"
-- vim.g.lazyvim_explorer = "neo-tree"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_mini_snippets_in_completion = false
vim.g.deprecation_warnings = true
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_eslint_auto_format = false
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"
-- vim.opt_local.spell = true

local opt = vim.opt

opt.autowrite = false
opt.autoread = true
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.

if vim.env.SSH_CONNECTION then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
            ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
            ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        },
    }
end
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0 -- disable concealing markup in markdown files and similiar
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
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
opt.formatoptions = "jcroqlnt" -- this was here as a comment before: tcqj
-- opt.formatoptions = "jcroqln" -- this was here as a comment before: tcqj -- then after this is was this: jcroqlnt -- current version has no t to prevent it from wrapping when typing, not sure if this has negative effects with lsp auto format..
-- opt.textwidth = 80
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" --nosplit -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 1 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = false
-- opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "…" }
-- opt.listchars = {
--     tab = "▸ ",
--     trail = "·",
--     extends = "»",
--     precedes = "«",
--     nbsp = "¬",
--     eol = "↲",
-- }
-- opt.listchars = {
--     tab = "» ",
--     trail = "·",
--     eol = "¬",
--     nbsp = "␣",
--     extends = "❯",
--     precedes = "❮",
--     lead = " ",
--     multispace = "· ",
-- }
opt.listchars = {
    tab = "▸ ",
    trail = "·",
    lead = "·",
    eol = "↲",
    nbsp = "␣",
    extends = "❯",
    precedes = "❮",
    multispace = "» ",
}
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.swapfile = false
opt.relativenumber = true -- Relative line numbers
opt.ruler = true -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
-- opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
-- opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "winpos", "help", "globals", "skiprtp", "folds", "localoptions" }
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "winpos", "help", "folds", "globals", "localoptions" }
--vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize", "winpos", "terminal", "localoptions" }
opt.shortmess:append({ S = false, W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode, use colors in statusline instead
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = false
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]
opt.tabstop = 2 -- Number of spaces tabs count for — how many columns wide an actual <Tab> character (\t) is displayed as. Purely visual for existing tabs in the file.
opt.softtabstop = 2 -- Number of spaces tabs count for — how many columns the <Tab> key and <BS> move/delete in insert mode, when editing. With your config (expandtab likely on elsewhere), pressing Tab inserts spaces up to this width, and Backspace removes that many as if it were one tabstop.
opt.shiftwidth = 2 -- Size of an indent — how many columns autoindent operations use: >>, <<, ==, and smartindent/autoindent behavior. This is what controls indent width when Neovim auto-indents code.
--  In short: tabstop = display width of literal tabs, softtabstop = editing behavior for the Tab/Backspace keys, shiftwidth = indentation commands. All three are set to 4 here so they behave consistently, but they're independent settings that can diverge
--  (e.g., tabstop=8, softtabstop=4, shiftwidth=4 is a common combo for files with real tabs but 4-space visual indents).
opt.shiftround = true -- Round indent
opt.breakindent = true -- default for lazyvim was false
opt.termguicolors = true -- True color support
opt.timeoutlen = 1000
opt.timeout = false
opt.ttimeoutlen = vim.g.is_mac and 0 or 10
opt.ttimeout = not vim.g.is_mac
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
        apex = "apexcode",
        cls = "apexcode",
        trigger = "apexcode",
        page = "visualforce",
        component = "visualforce",
        godpowers = "xml",
    },
    filename = {
        [".env"] = "sh",
    },
    pattern = {
        ["%.env%.[%w_.-]+"] = "sh",
        ["%.cls"] = "apexcode",
    },
})
-- custom status line
-- vim.g.mode_colors = {
--     n = "StatusLineSection",
--     v = "StatusLineSectionV",
--     ["^V"] = "StatusLineSectionV", -- ^V (visual block)
--     i = "StatusLineSectionI",
--     c = "StatusLineSectionC",
--     r = "StatusLineSectionR",
-- }
--
-- vim.g.statusline_left = "[%n]%#StatusLine# %<%f%r%h%m%w"
-- vim.g.statusline_extra_right = ""
--
-- function StatusLineRenderer()
--     local m = vim.fn.mode():lower()
--     local hl = "%#" .. (vim.g.mode_colors[m] or vim.g.mode_colors.n) .. "#"
--     return hl .. vim.g.statusline_left .. " %=" .. vim.g.statusline_extra_right .. " %y %-14.(%l,%c%V%)%P "
-- end

-- only set default statusline once on initial startup
-- if vim.fn.has("vim_starting") == 1 then
-- vim.o.statusline = vim.g.statusline_left
-- end

-- local statusline_group = vim.api.nvim_create_augroup("statusline_update", { clear = true })

-- show focussed buffer statusline
-- vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter", "WinEnter", "BufWinEnter" }, {
--     group = statusline_group,
--     callback = function()
--          vim.wo.statusline = "%!v:lua.StatusLineRenderer()"
--     end,
-- })

-- show blurred buffer statusline
-- vim.api.nvim_create_autocmd({ "FocusLost", "VimLeave", "WinLeave" }, {
--     group = statusline_group,
--     callback = function()
--          vim.wo.statusline = ""
--     end,
-- })

-- native statusline with filetype appended
-- opt.statusline = "[%n] %<%f %h%m%r%=%-14.(%l,%c%V%) %P %y"
-- opt.statusline = "[%n] %<%f%r%h%m%w %= %y %-14.(%l,%c%V%)%P "

-- neovim's actual built-in default statusline (see `nvim --clean` vim.o.statusline) with filetype appended
local nvim_default_statusline = table.concat({
    [[%<%f %h%w%m%r ]],
    [[%{% v:lua.require('vim._core.util').term_exitcode() %}]],
    [[%=]],
    [[%{% luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ')%}]],
    [[%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}]],
    [[%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}]],
    [[%{% &busy > 0 ? '◐ ' : '' %}]],
    [[%y ]],
    [[%{% luaeval('(package.loaded[''vim.diagnostic''] and next(vim.diagnostic.count()) and vim.diagnostic.status() .. '' '') or ''[no diag] '' ') %}]],
    [[%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %} ]],
})
local orig_statusline = opt.statusline
opt.statusline = nvim_default_statusline

vim.keymap.set("n", "<localleader>QD", function()
    opt.statusline = nvim_default_statusline
end)
vim.keymap.set("n", "<localleader>QF", function()
    opt.statusline = orig_statusline
end)
vim.keymap.set("n", "<localleader>QG", function()
    opt.statusline = "[%n] %<%f%r%h%m%w %= %y %-14.(%l,%c%V%)%P "
end)
vim.keymap.set("n", "<localleader>QH", function()
    opt.statusline = "[%n] %<%f %a%w%h%m%r%=%S %k%y %-14.(%l,%c%V%) %P "
end)
-- opt.statusline = "[%n] %<%f %a%w%h%m%r%=%S %k%y %-14.(%l,%c%V%) %P "
-- opt.statusline =
-- "%<%f %h%w%m%r %{% v:lua.require('vim._core.util').term_exitcode() %}%=%{% luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ')%}%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}%{% &busy > 0 ? '◐ ' : '' %}%{% luaeval('(package.loaded[''vim.diagnostic''] and next(vim.diagnostic.count()) a nd vim.diagnostic.status() .. '' '') or '''' ') %}%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerf ormat ) : '' %}"
